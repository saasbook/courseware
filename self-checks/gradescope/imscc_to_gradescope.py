#!/usr/bin/env python3
"""Extract Self-Check questions from an IMS Common Cartridge (.imscc) export
and emit Gradescope-compatible Markdown, one file per course module.

The Fall 2025 "Introduction to Software Engineering" Canvas export bundles each
in-lecture Self-Check as a QTI 1.2 assessment.  Canvas titles them
``Self-Check X.Y: <topic>`` in the course organization, where ``X`` is the
module number and ``Y`` the submodule.  This script:

  1. Reads ``imsmanifest.xml`` to find every item whose title starts with
     "Self-Check", resolving its ``identifierref`` to the QTI assessment file.
  2. Parses each QTI assessment into questions (prompt, choices, correct
     answer(s), feedback), converting the embedded HTML to Markdown.
  3. Groups the questions by module and writes one
     ``Module X Self-Checks.md`` file, with questions separated by ``---``.

Gradescope's online-assignment Markdown is used for the answer choices:

  * single-answer multiple choice -> ``( )`` / ``(x)`` radio options
  * select-all-that-apply         -> ``[ ]`` / ``[x]`` checkbox options
  * free response (essay/fill-in)  -> the prompt only (manually graded)

The ``(x)`` / ``[x]`` markers tell Gradescope which option is correct so the
questions can be autograded after import.

Usage:
    python imscc_to_gradescope.py [CARTRIDGE] [-o OUTPUT_DIR]

``CARTRIDGE`` may be either the ``.imscc`` (zip) file or an already-extracted
cartridge directory.  If omitted, the script looks for a single ``*.imscc`` in
the current directory.
"""

import argparse
import glob
import html
import os
import re
import shutil
import sys
import tempfile
import zipfile
from html.parser import HTMLParser
from xml.etree import ElementTree as ET

# XML namespaces used by the cartridge.
NS_MANIFEST = "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1"
NS_QTI = "http://www.imsglobal.org/xsd/ims_qtiasiv1p2"

# Canvas replaces uploaded-file references with this placeholder, which maps to
# the ``web_resources`` directory inside the cartridge.
FILEBASE = "$IMS-CC-FILEBASE$"


# --------------------------------------------------------------------------- #
# HTML -> Markdown
# --------------------------------------------------------------------------- #
class _HTMLToMarkdown(HTMLParser):
    """Best-effort conversion of the small HTML subset Canvas emits into
    Markdown.  Returns plain text with Markdown emphasis, lists, images, and
    code spans preserved; everything else degrades to plain text."""

    def __init__(self, image_rewriter=None):
        super().__init__(convert_charrefs=True)
        self._image_rewriter = image_rewriter or (lambda src: src)
        self._out = []
        self._list_stack = []  # 'ul' or 'ol'
        self._ol_index = []

    # -- helpers ----------------------------------------------------------- #
    def _emit(self, text):
        self._out.append(text)

    def _newline(self):
        if self._out and not self._out[-1].endswith("\n"):
            self._emit("\n")

    # -- tag handlers ------------------------------------------------------ #
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag in ("p", "div"):
            self._newline()
        elif tag == "br":
            self._emit("\n")
        elif tag in ("strong", "b"):
            self._emit("**")
        elif tag in ("em", "i"):
            self._emit("_")
        elif tag == "code":
            self._emit("`")
        elif tag == "pre":
            self._newline()
            self._emit("```\n")
        elif tag in ("ul", "ol"):
            self._newline()
            self._list_stack.append(tag)
            self._ol_index.append(0)
        elif tag == "li":
            self._newline()
            if self._list_stack and self._list_stack[-1] == "ol":
                self._ol_index[-1] += 1
                self._emit(f"{self._ol_index[-1]}. ")
            else:
                self._emit("- ")
        elif tag in ("h1", "h2", "h3", "h4", "h5", "h6"):
            self._newline()
            self._emit("**")
        elif tag == "img":
            src = self._image_rewriter(attrs.get("src", ""))
            alt = attrs.get("alt", "").strip()
            self._emit(f"![{alt}]({src})")

    def handle_endtag(self, tag):
        if tag in ("p", "div"):
            self._newline()
        elif tag in ("strong", "b"):
            self._emit("**")
        elif tag in ("em", "i"):
            self._emit("_")
        elif tag == "code":
            self._emit("`")
        elif tag == "pre":
            self._newline()
            self._emit("```\n")
        elif tag in ("ul", "ol"):
            if self._list_stack:
                self._list_stack.pop()
                self._ol_index.pop()
            self._newline()
        elif tag in ("h1", "h2", "h3", "h4", "h5", "h6"):
            self._emit("**")
            self._newline()

    def handle_data(self, data):
        self._emit(data)

    # -- result ------------------------------------------------------------ #
    def text(self):
        raw = "".join(self._out)
        # Collapse runs of blank lines and trim trailing whitespace per line.
        lines = [ln.rstrip() for ln in raw.split("\n")]
        out, blank = [], False
        for ln in lines:
            if ln == "":
                if not blank and out:
                    out.append("")
                blank = True
            else:
                out.append(ln)
                blank = False
        return "\n".join(out).strip()


def html_to_markdown(raw, image_rewriter=None):
    """Convert a QTI HTML/text fragment to Markdown."""
    if raw is None:
        return ""
    parser = _HTMLToMarkdown(image_rewriter=image_rewriter)
    parser.feed(html.unescape(raw) if "&lt;" in raw or "&amp;" in raw else raw)
    return parser.text()


# --------------------------------------------------------------------------- #
# QTI parsing
# --------------------------------------------------------------------------- #
def _q(tag):
    return f"{{{NS_QTI}}}{tag}"


def _mattext(material_el):
    """Return the concatenated raw text of all <mattext> under an element."""
    if material_el is None:
        return ""
    parts = [mt.text or "" for mt in material_el.iter(_q("mattext"))]
    return "".join(parts)


def _correct_idents(item_el):
    """Return the set of response_label idents that the resprocessing rewards
    with the maximum SCORE (i.e. the correct answers)."""
    correct = set()
    resprocessing = item_el.find(_q("resprocessing"))
    if resprocessing is None:
        return correct

    # Determine the maximum achievable score (usually 100).
    maxscore = 0.0
    decvar = resprocessing.find(f"{_q('outcomes')}/{_q('decvar')}")
    if decvar is not None and decvar.get("maxvalue"):
        try:
            maxscore = float(decvar.get("maxvalue"))
        except ValueError:
            maxscore = 0.0

    for cond in resprocessing.findall(_q("respcondition")):
        setvars = cond.findall(_q("setvar"))
        awards_max = False
        for sv in setvars:
            if (sv.get("varname") or "").upper() != "SCORE":
                continue
            try:
                val = float((sv.text or "0").strip())
            except ValueError:
                continue
            # Treat a Set to the max value (or any positive Add) as "correct".
            action = (sv.get("action") or "Set").lower()
            if (action == "set" and maxscore and val >= maxscore) or (
                action == "add" and val > 0
            ):
                awards_max = True
        if awards_max:
            for ve in cond.find(_q("conditionvar")).iter(_q("varequal")):
                if ve.text:
                    correct.add(ve.text.strip())
    return correct


def parse_assessment(path, image_rewriter=None):
    """Parse a QTI assessment file into a dict with title and questions."""
    tree = ET.parse(path)
    root = tree.getroot()
    assessment = root.find(_q("assessment"))
    title = assessment.get("title", "") if assessment is not None else ""

    questions = []
    container = assessment if assessment is not None else root
    for item in container.iter(_q("item")):
        presentation = item.find(_q("presentation"))
        if presentation is None:
            continue

        # Prompt: the <material> that is a direct child of <presentation>.
        prompt_material = presentation.find(_q("material"))
        prompt = html_to_markdown(_mattext(prompt_material), image_rewriter)

        response_lid = presentation.find(_q("response_lid"))
        response_str = presentation.find(_q("response_str"))

        if response_lid is not None:
            cardinality = response_lid.get("rcardinality", "Single")
            correct = _correct_idents(item)
            choices = []
            for label in response_lid.iter(_q("response_label")):
                ident = label.get("ident")
                text = html_to_markdown(
                    _mattext(label.find(_q("material"))), image_rewriter
                )
                choices.append(
                    {"text": text, "correct": ident in correct}
                )
            qtype = "multiple_answers" if cardinality == "Multiple" else "multiple_choice"
            questions.append(
                {"type": qtype, "prompt": prompt, "choices": choices,
                 "feedback": _item_feedback(item, image_rewriter)}
            )
        elif response_str is not None:
            # Fill-in / essay: free response, no autogradable choices.
            questions.append(
                {"type": "free_response", "prompt": prompt, "choices": [],
                 "feedback": _item_feedback(item, image_rewriter)}
            )
        else:
            # Unknown / text-only item: keep the prompt so nothing is lost.
            questions.append(
                {"type": "text", "prompt": prompt, "choices": [],
                 "feedback": _item_feedback(item, image_rewriter)}
            )

    return {"title": title, "questions": questions}


def _item_feedback(item_el, image_rewriter=None):
    """Return the general feedback/explanation text for an item, if any."""
    texts = []
    for fb in item_el.findall(_q("itemfeedback")):
        material = fb.find(f"{_q('flow_mat')}/{_q('material')}")
        if material is None:
            material = fb.find(_q("material"))
        txt = html_to_markdown(_mattext(material), image_rewriter)
        if txt:
            texts.append(txt)
    return "\n\n".join(texts)


# --------------------------------------------------------------------------- #
# Manifest parsing
# --------------------------------------------------------------------------- #
def _m(tag):
    return f"{{{NS_MANIFEST}}}{tag}"


def build_resource_map(manifest_root):
    """Map resource identifier -> primary assessment file href."""
    resources = {}
    res_parent = manifest_root.find(_m("resources"))
    if res_parent is None:
        return resources
    for res in res_parent.findall(_m("resource")):
        ident = res.get("identifier")
        rtype = res.get("type", "")
        if "assessment" not in rtype:
            continue
        # The QTI file is the first <file> whose href ends in an xml file.
        href = None
        for f in res.findall(_m("file")):
            fh = f.get("href", "")
            if fh.endswith(".xml") and ("qti" in fh or "assessment" in fh):
                href = fh
                break
        if href is None and res.findall(_m("file")):
            href = res.findall(_m("file"))[0].get("href")
        if href:
            resources[ident] = href
    return resources


SELFCHECK_RE = re.compile(r"Self-Check\s+(\d+)\.(\d+)", re.IGNORECASE)


def find_self_checks(manifest_root, resource_map):
    """Walk the organization tree and return a list of self-check entries:
    {module, submodule, title, href} ordered by their position in the course."""
    entries = []
    orgs = manifest_root.find(_m("organizations"))
    if orgs is None:
        return entries

    for item in orgs.iter(_m("item")):
        title_el = item.find(_m("title"))
        if title_el is None or not title_el.text:
            continue
        title = title_el.text.strip()
        match = SELFCHECK_RE.search(title)
        if not match:
            continue
        ref = item.get("identifierref")
        href = resource_map.get(ref)
        if not href:
            continue
        entries.append(
            {
                "module": int(match.group(1)),
                "submodule": int(match.group(2)),
                "title": title,
                "href": href,
            }
        )
    return entries


# --------------------------------------------------------------------------- #
# Markdown rendering
# --------------------------------------------------------------------------- #
def render_question(prompt, question):
    """Render a single parsed question as Gradescope Markdown."""
    lines = []
    if prompt:
        lines.append(f"**{prompt}**" if "\n" not in prompt else prompt)
    else:
        lines.append("**(see prompt)**")

    q_prompt = question["prompt"]
    if q_prompt and q_prompt != prompt:
        lines.append("")
        lines.append(q_prompt)

    lines.append("")
    if question["type"] in ("multiple_choice", "multiple_answers"):
        open_mark = "[ ]" if question["type"] == "multiple_answers" else "( )"
        close_mark = "[x]" if question["type"] == "multiple_answers" else "(x)"
        for choice in question["choices"]:
            mark = close_mark if choice["correct"] else open_mark
            text = choice["text"].replace("\n", " ").strip()
            lines.append(f"{mark} {text}")
    elif question["type"] == "free_response":
        lines.append("_Free response — graded manually._")
    # 'text' type: prompt already shown above.

    if question.get("feedback"):
        lines.append("")
        # Gradescope explanations are wrapped in [[ ]] and must each start and
        # end on a single line; multiple lines are concatenated on display.
        for segment in question["feedback"].split("\n"):
            segment = " ".join(segment.split()).strip()
            if segment:
                lines.append(f"[[{segment}]]")

    return "\n".join(lines).rstrip()


def render_module(module_num, self_checks):
    """Render the full ``Module X Self-Checks.md`` body."""
    out = [f"# Module {module_num} Self-Checks", ""]
    blocks = []
    for sc in self_checks:
        # Each self-check assessment usually holds exactly one question, but we
        # handle multiples gracefully.  The prompt header is the assessment
        # title (e.g. "Self-Check 1.2: ...").
        for q in sc["assessment"]["questions"]:
            blocks.append(render_question(sc["title"], q))
    out.append("\n\n---\n\n".join(blocks))
    out.append("")
    return "\n".join(out)


# --------------------------------------------------------------------------- #
# Image handling
# --------------------------------------------------------------------------- #
def make_image_rewriter(cartridge_dir, images_out_dir):
    """Return a function that rewrites a QTI <img> src to a local relative path,
    copying the referenced file out of the cartridge's web_resources."""
    copied = {}

    def rewriter(src):
        if not src:
            return src
        if src.startswith(FILEBASE):
            rel = src[len(FILEBASE):].lstrip("/")
            source_path = os.path.join(cartridge_dir, "web_resources", rel)
            if os.path.exists(source_path):
                fname = os.path.basename(rel)
                if fname not in copied:
                    os.makedirs(images_out_dir, exist_ok=True)
                    shutil.copy2(source_path, os.path.join(images_out_dir, fname))
                    copied[fname] = True
                return f"images/{fname}"
            return rel
        return src  # external URL — leave as-is

    return rewriter


# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
def resolve_cartridge(path):
    """Return (cartridge_dir, cleanup_dir). Extracts a zip to a temp dir if
    needed; cleanup_dir is non-None only when a temp dir must be removed."""
    if os.path.isdir(path):
        return path, None
    if zipfile.is_zipfile(path):
        tmp = tempfile.mkdtemp(prefix="imscc_")
        with zipfile.ZipFile(path) as zf:
            zf.extractall(tmp)
        return tmp, tmp
    raise SystemExit(f"error: {path!r} is neither a directory nor a zip file")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("cartridge", nargs="?",
                        help="path to the .imscc file or extracted cartridge dir")
    parser.add_argument("-o", "--output", default="modules",
                        help="output directory for the markdown files (default: ./modules)")
    args = parser.parse_args(argv)

    cartridge = args.cartridge
    if cartridge is None:
        candidates = glob.glob("*.imscc") + glob.glob("*.imscc.zip")
        if len(candidates) != 1:
            parser.error("could not find a unique *.imscc file; pass one explicitly")
        cartridge = candidates[0]

    cartridge_dir, cleanup = resolve_cartridge(cartridge)
    try:
        manifest_path = os.path.join(cartridge_dir, "imsmanifest.xml")
        if not os.path.exists(manifest_path):
            raise SystemExit(f"error: no imsmanifest.xml found in {cartridge_dir}")

        manifest_root = ET.parse(manifest_path).getroot()
        resource_map = build_resource_map(manifest_root)
        self_checks = find_self_checks(manifest_root, resource_map)
        if not self_checks:
            raise SystemExit("error: no Self-Check assessments found in manifest")

        os.makedirs(args.output, exist_ok=True)
        image_rewriter = make_image_rewriter(
            cartridge_dir, os.path.join(args.output, "images")
        )

        # Parse each self-check assessment.
        for sc in self_checks:
            qti_path = os.path.join(cartridge_dir, sc["href"])
            sc["assessment"] = parse_assessment(qti_path, image_rewriter)

        # Group by module, ordered by submodule.
        modules = {}
        for sc in self_checks:
            modules.setdefault(sc["module"], []).append(sc)

        total_q = 0
        for module_num in sorted(modules):
            scs = sorted(modules[module_num], key=lambda s: s["submodule"])
            body = render_module(module_num, scs)
            out_path = os.path.join(args.output, f"Module {module_num} Self-Checks.md")
            with open(out_path, "w", encoding="utf-8") as fh:
                fh.write(body)
            n_q = sum(len(s["assessment"]["questions"]) for s in scs)
            total_q += n_q
            print(f"Module {module_num:>2}: {len(scs):>2} self-checks, "
                  f"{n_q:>2} questions -> {out_path}")

        print(f"\nWrote {len(modules)} module files covering "
              f"{len(self_checks)} self-checks / {total_q} questions "
              f"to {args.output}/")
    finally:
        if cleanup:
            shutil.rmtree(cleanup, ignore_errors=True)


if __name__ == "__main__":
    main()

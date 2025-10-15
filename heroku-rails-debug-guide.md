# Rails on Heroku: Debugging & Deployment Guide

A debugging reference for deploying Rails applications to Heroku, designed for students unfamiliar with Rails or Heroku.

> [!NOTE]
> This is a generic version of a guide for all ESaaS assignments.
> Not every bit of advice applies to every Rails or Heroku app.
> Use your own judgement and _ask questions_ if you're unsure.

**References:**
- [Heroku Dev Center](https://devcenter.heroku.com/)
- [Getting Started with Rails on Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails7)
- [Heroku CLI Reference](https://devcenter.heroku.com/articles/heroku-cli)

---

## Table of Contents

1. [How to Ask for Help Effectively](#how-to-ask-for-help-effectively)
2. [Understanding Heroku's Architecture](#understanding-herokus-architecture)
3. [Development vs Production Deployment](#development-vs-production-deployment)
4. [Prerequisites & Installation](#prerequisites--installation)
5. [Heroku CLI Basics](#heroku-cli-basics)
4. [Viewing Logs (Your Primary Debugging Tool)](#viewing-logs-your-primary-debugging-tool)
5. [Connecting to the Database](#connecting-to-the-database)
6. [Heroku Dashboard](#heroku-dashboard)
7. [Environment Variables (Config Vars)](#environment-variables-config-vars)
8. [Git Remotes and Deployment](#git-remotes-and-deployment)
9. [Deploying Different Rails App + DB to Same Container](#deploying-different-rails-app--db-to-same-container)
10. [Debugging Methodology](#debugging-methodology)
11. [Common Issues & Solutions](#common-issues--solutions)
12. [Additional Topics](#additional-topics)

---

## How to Ask for Help Effectively

When you're stuck and need help from instructors, TAs, or classmates, **how you ask makes a huge difference**. A good question gets you help faster.

### Basic Structure

**1. Show what you've tried**

Bad: "My app doesn't work on Heroku"
Good: "My app crashes on Heroku. I've tried checking the logs and DATABASE_URL is set. Here's what I'm seeing..."


**2. Include the entire log output**

Bad: "I get an error about the database"
Good: "I get this error:" (followed by complete log output)

**Why this matters:** Error messages have context. The line before/after the error often contains the real cause.

**3. Format your code and logs properly**

Use monospaced/preformatted text for all code, commands, and log output. This makes it readable.

#### In Markdown (Slack, Discord, GitHub Issues)

For inline code, use single backticks:

```
Type `heroku logs` to view logs
```

For multi-line code or logs, use triple backticks:

````
```
heroku logs --tail -a my-app
2025-10-13T15:30:45.123456+00:00 app[web.1]: Error: Database connection failed
2025-10-13T15:30:45.234567+00:00 app[web.1]: FATAL: database "myapp" does not exist
```
````

#### In Visual Editors (Canvas, Google Docs)

Look for:
- **Code block** button (usually looks like `</>`)
- **Monospace font** option (often Courier, Consolas, or Monaco)
- **Preformatted text** style

**What NOT to do:**
- ❌ Screenshots of text (hard to read, can't copy/paste)
- ❌ "...and more errors" (include the full output)
- ❌ Regular paragraph text for logs (unreadable)

### A Good Help Request Template

````
**What I'm trying to do:**
Deploy my Rails app to Heroku

**What's happening:**
The app crashes immediately after deployment

**What I've tried:**
1. Checked logs with `heroku logs --tail`
2. Verified DATABASE_URL is set with `heroku config`
3. Ran migrations with `heroku run rails db:migrate`

**Full log output:**
```
2025-10-13T15:30:45.123456+00:00 app[web.1]: [entire error here]
```

**Link to my GitHub repo:**
https://github.com/username/project

**Heroku app name:**
my-app-staging
````

### When to Include Links

**Always include:**
- Link to your GitHub repo (if public, or accessible to the course staff reading the question)
- Link to Heroku app (if accessible)
- Links to documentation you've read
- Links to related Stack Overflow questions
- Links to ChatGPT / Claude chat sessions if using them.

**Example:**
"I followed this guide [link] but I'm getting a different error than what's shown..."

### Common Mistakes to Avoid

❌ "It doesn't work" (too vague)
❌ "I get an error" (which error? show it!)
❌ "Same problem as before" (context is missing)
❌ Asking in multiple places simultaneously without mentioning it
❌ Not responding when someone asks for more info

✅ "My app shows 'Application Error'. Here are my logs: [logs]. I've checked X, Y, Z."
✅ "Following up on my earlier question with requested info..."

---

## Understanding Heroku's Architecture

### What is Heroku?

Heroku is a **Platform as a Service (PaaS)**. Instead of managing your own Linux server, you push code to Heroku and it handles:
- Running your application
- Providing a database
- Routing HTTP requests
- Collecting logs

### Key Concepts

**Dynos:** Lightweight containers that run your code. Think of them as isolated virtual machines that run a single process.
- A "web" dyno runs your Rails server and handles HTTP requests
- A "worker" dyno runs background jobs
- Free dynos "sleep" after 30 minutes of inactivity

**Why this matters for debugging:** If your dyno crashes, your app goes down. When debugging, you're often trying to figure out *why* the dyno crashed.

**Buildpacks:** Scripts that install dependencies and prepare your app to run. The Ruby buildpack:
- Installs the correct Ruby version
- Runs `bundle install`
- Precompiles assets
- Sets up environment

**Why this matters for debugging:** Build errors happen during this phase. If `bundle install` fails or assets won't compile, your deploy fails *before* your app even tries to run.

**Ephemeral filesystem:** Each dyno has its own filesystem, but it's **temporary**. Files written during runtime disappear when the dyno restarts.

**Why this matters for debugging:** Don't store uploaded files on the filesystem. Use S3 or similar. Database is persistent, filesystem is not. Your application probably doesn't rely on the filesystem for this course.

**The Git-based workflow:** You deploy by pushing to a special Git remote. Heroku detects your app type and builds it.

**Why this matters for debugging:** If you can't push, check your Git remote configuration. If the build fails, check the build logs (not runtime logs).

### Heroku Git Remote Format

Heroku uses a special Git remote URL for deployment:

```
https://git.heroku.com/<your-app-name>.git
```

When you run `heroku create`, this remote is automatically added to your repository as `heroku`. You can view it with:

```bash
git remote -v
```

To manually add or update the Heroku remote:

```bash
heroku git:remote -a <your-app-name>
```

> [!TIP]
> Always verify you're pushing to the correct remote before deploying.

---

## Development vs Production Deployment

### Why Development and Production Are Different

**Key concept:** Your local development environment is NOT the same as Heroku's production environment. Many deploy issues come from these differences.

**Main differences:**

| Aspect | Development (Your Computer) | Production (Heroku) |
|--------|----------------------------|---------------------|
| Database | SQLite (file-based) | PostgreSQL (server-based) |
| Assets | Served directly by Rails | Precompiled, served statically |
| Environment | `RAILS_ENV=development` | `RAILS_ENV=production` |
| Error Pages | Detailed stack traces | Generic error page |
| Code Changes | Auto-reload | Requires new deploy |
| File Storage | Local filesystem (persists) | Ephemeral (disappears) |

**Why this matters:** Code that works locally might fail on Heroku because of these differences.

### Database: SQLite vs PostgreSQL

**The problem:** SQLite is file-based and can't scale. Heroku uses PostgreSQL.

**How to configure this:**

```ruby
# Gemfile
group :development, :test do
  gem 'sqlite3'  # Only for local development
end

group :production do
  gem 'pg'       # PostgreSQL for Heroku
end
```

**Why separate them:** You want fast, simple SQLite locally, but production-grade PostgreSQL on Heroku.

**How to test locally with PostgreSQL:**

1. Install PostgreSQL:
   ```bash
   brew install postgresql  # macOS
   ```

2. Update `config/database.yml`:
   ```yaml
   development:
     adapter: postgresql
     database: myapp_development
     pool: 5
     timeout: 5000
   ```

3. Create database:
   ```bash
   rails db:create
   rails db:migrate
   ```

**Why test with Postgres locally:** Catch SQL compatibility issues before deploying. SQLite and Postgres have subtle differences (e.g., case sensitivity, date functions).

### Asset Compilation

**What are assets:** CSS, JavaScript, images - anything in `app/assets/`

**The difference:**

**Development:**
- Rails serves assets on-the-fly
- Changes appear immediately when you refresh
- Each file served separately (slow but convenient)

**Production:**
- Assets must be **precompiled** during deployment
- Combined into fewer files for performance
- Served with fingerprinted filenames (e.g., `application-a1b2c3d4.js`)

**What happens during Heroku deploy:**

```bash
# Heroku runs this automatically:
RAILS_ENV=production rails assets:precompile
```

This creates files in `public/assets/` (but you never commit these!)

**Common asset errors:**

**Error:** "Asset precompilation failed"
**Cause:** JavaScript or CSS syntax error, missing Node.js
**Fix:** Check build logs for the specific error

**Error:** CSS/JS not loading in production
**Cause:** Rails not configured to serve static files
**Fix:**
```bash
heroku config:set RAILS_SERVE_STATIC_FILES=enabled -a your-app-name
```

### Environment Variables

**Development:**
```ruby
ENV['SECRET_KEY_BASE']  # Read from .env file or set in terminal
```

**Production (Heroku):**
```bash
heroku config:set SECRET_KEY_BASE=abc123...
```

**Why different:** You don't want production secrets in your development `.env` file, and you definitely don't want them in Git.

### Testing Production Behavior Locally

**Problem:** How do you test production settings without deploying?

**Solution:** Run your app in production mode locally.

#### Step 1: Precompile assets

```bash
RAILS_ENV=production rails assets:precompile
```

#### Step 2: Set required environment variables

```bash
export SECRET_KEY_BASE=$(rails secret)
export RAILS_SERVE_STATIC_FILES=enabled
export DATABASE_URL=postgresql://localhost/myapp_production
```

#### Step 3: Create production database

```bash
RAILS_ENV=production rails db:create
RAILS_ENV=production rails db:migrate
```

#### Step 4: Run in production mode

```bash
RAILS_ENV=production rails server
```

Visit `http://localhost:3000` - you're now running in production mode locally.

**What to test:**
- ✅ Do assets load?
- ✅ Does the database connect?
- ✅ Do environment variables work?
- ✅ Are error pages showing generic messages (not stack traces)?

**Cleanup after testing:**

```bash
rails assets:clobber  # Remove compiled assets
```

### Using Heroku Local

**Better solution:** Use `heroku local` to simulate Heroku's environment.

Create a `Procfile` (tells Heroku how to run your app):

```
web: bundle exec puma -C config/puma.rb
```

Create a `.env` file (don't commit this!):

```bash
# .env
DATABASE_URL=postgresql://localhost/myapp_development
SECRET_KEY_BASE=your_dev_secret_here
RAILS_ENV=development
```

Run locally:

```bash
heroku local web
```

**What this does:** Reads your `Procfile` and `.env`, runs your app exactly as Heroku would (but with your dev database).

**Why use this:** Catches Procfile issues, environment variable problems, and other Heroku-specific config before deploying.

### Quick Checklist Before First Deploy

- [ ] `pg` gem in production group
- [ ] `sqlite3` gem in development/test groups only
- [ ] `Procfile` exists with `web:` process
- [ ] Database configured to read `DATABASE_URL` in production
- [ ] `.env` file in `.gitignore` (never commit secrets!)
- [ ] Tested with `heroku local web`
- [ ] Required config vars identified (SECRET_KEY_BASE, etc.)

---

## Prerequisites & Installation

Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

```bash
brew install heroku/brew/heroku  # macOS
```

```bash
curl https://cli-assets.heroku.com/install.sh | sh  # Linux
```

Download from [heroku.com](https://devcenter.heroku.com/articles/heroku-cli) for Windows.

Verify installation:

```bash
heroku --version
```

**Why you need this:** The Heroku CLI is how you interact with Heroku from your terminal. It's required for viewing logs, running commands on your production app, and deploying.

---

## Heroku CLI Basics

### Authentication

Login to Heroku (opens browser):

```bash
heroku login
```

Login from terminal only:

```bash
heroku login -i
```

Check who's logged in:

```bash
heroku whoami
```

> [!NOTE]
> Authentication tokens are stored in `~/.netrc`. If you have login issues, try moving this file temporarily.

**Why authentication matters:** Every Heroku command needs to authenticate you. If you're getting permission errors, verify you're logged in as the correct user.

### Common Commands

List your apps:

```bash
heroku apps
```

Get app info:

```bash
heroku apps:info -a your-app-name
```

Open app in browser:

```bash
heroku open -a your-app-name
```

Run Rails console (connects to production database!):

```bash
heroku run rails console -a your-app-name
```

Run migrations:

```bash
heroku run rails db:migrate -a your-app-name
```

> [!TIP]
> If you have multiple Heroku apps, always use the `-a app-name` flag or set the `HEROKU_APP` environment variable to avoid "multiple apps in git remotes" errors.

**Why `-a app-name` is important:** If you have multiple Heroku remotes in your Git repo (staging + production), Heroku doesn't know which one you mean. Using `-a` or `--app` is explicit.

**Reference:** [Heroku CLI Usage](https://devcenter.heroku.com/articles/using-the-cli)

---

## Viewing Logs (Your Primary Debugging Tool)

### Why Logs Are Critical

**Logs are your window into production.** Unlike local development where you see errors in your terminal, on Heroku you can't see what's happening without logs. Logs show:
- Application errors and stack traces
- HTTP requests and responses
- Database queries (if logging is enabled)
- System events (dyno starts, crashes, out-of-memory errors)

**The golden rule of debugging:** When something doesn't work, check the logs first.

### Basic Log Commands

View recent logs (last ~100 lines):

```bash
heroku logs -a your-app-name
```

View more logs (up to 1,500 lines):

```bash
heroku logs -n 1500 -a your-app-name
```

Tail logs in real-time (keep terminal open, see logs as they happen):

```bash
heroku logs --tail -a your-app-name
```

**When to use each:**
- `heroku logs` - Quick check after a deploy or when investigating an error
- `heroku logs -n 1500` - When you need more history (maximum Heroku keeps)
- `heroku logs --tail` - When actively debugging; you make a request and see the log output immediately

> [!TIP]
> To get even more log history, pipe output to a file:
> ```bash
> heroku logs -n 1500 -a your-app-name > heroku_logs.txt
> ```
> Then you can search through the file or share it when asking for help.

> [!WARNING]
> Heroku only keeps the most recent 1,500 log lines for up to 1 week. For production apps, add a [logging add-on](https://elements.heroku.com/addons#logging) for persistent logs.

### Filtering Logs

Show only app logs (not system logs):

```bash
heroku logs --source app -a your-app-name
```

Show only web dyno logs:

```bash
heroku logs --dyno web -a your-app-name
```

Show specific process type:

```bash
heroku logs --process-type web -a your-app-name
```

**Why filtering matters:** System logs (router, dyno starts) can be noisy. Filtering to `--source app` shows only your application's output (Rails logs, puts statements, errors).

### Understanding Log Format

Heroku logs follow this format:

```
timestamp source[dyno]: message
```

Example:

```
2025-10-13T15:30:45.123456+00:00 app[web.1]: Started GET "/posts" for 1.2.3.4
2025-10-13T15:30:45.234567+00:00 heroku[router]: at=info method=GET path="/posts"
```

**Sources to understand:**
- `app[web.1]` - Your Rails application code (this is where Ruby errors appear)
- `heroku[router]` - HTTP routing layer (shows request details, 404s, 503s)
- `heroku[web.1]` - Dyno process events (crashes, memory exceeded)
- `heroku[api]` - Heroku platform events (deploys, config changes)

**How to read logs when debugging:**

1. **Look for error messages** - Search for "error", "exception", "failed"
2. **Check timestamps** - When did the error occur? Does it correlate with a deploy or config change?
3. **Follow the request flow** - Find the router log entry, then look for corresponding app logs
4. **Look for crashes** - Lines like "State changed from up to crashed" indicate your dyno died

> [!TIP]
> Logs are not in strict chronological order due to distributed architecture. Look at timestamps when debugging timing issues.

### Common Log Patterns

**Application crashed:**
```
heroku[web.1]: State changed from up to crashed
heroku[web.1]: Process exited with status 1
```
**What this means:** Your Rails app crashed. Look at app logs above this to see the error.

**Memory exceeded (R14):**
```
heroku[web.1]: Process running mem=512M(100.0%)
heroku[web.1]: Error R14 (Memory quota exceeded)
```
**What this means:** Your app used too much RAM. You need to optimize or upgrade dynos.

**Request timeout (H12):**
```
heroku[router]: at=error code=H12 desc="Request timeout"
```
**What this means:** A request took longer than 30 seconds. Check for slow database queries or external API calls.

**Reference:** [Heroku Logging](https://devcenter.heroku.com/articles/logging)

---

## Connecting to the Database

### Understanding Heroku Postgres

**Key concept:** Heroku Postgres is a managed PostgreSQL database. You don't manage the server; Heroku does. You interact with it via standard PostgreSQL tools.

**The DATABASE_URL:** Heroku automatically creates an environment variable called `DATABASE_URL` that contains the connection string. Rails reads this automatically in production.

**Why this matters:** If your app can't connect to the database, it's usually because:
1. The database addon doesn't exist
2. DATABASE_URL isn't set
3. Rails isn't configured to read DATABASE_URL

### Database Connection Basics

Provision a Postgres database:

```bash
heroku addons:create heroku-postgresql:essential-0 -a your-app-name
```

Check database info:

```bash
heroku pg:info -a your-app-name
```

View database credentials:

```bash
heroku pg:credentials:url -a your-app-name
```

> [!WARNING]
> Database credentials can change during maintenance or failovers. Always use the `DATABASE_URL` config var, never hardcode credentials.

**Why credentials change:** Heroku rotates database credentials for security. If you hardcode them, your app will break when they rotate. Always read from `ENV['DATABASE_URL']`.

### Connecting via psql

Connect to database console (requires local PostgreSQL installation):

```bash
heroku pg:psql -a your-app-name
```

On macOS, install PostgreSQL:

```bash
brew install postgresql
```

**What `pg:psql` does:** Opens an interactive SQL shell connected to your production database. You can run SQL queries directly. Be careful - you're in production!

> [!NOTE]
> On Windows, you need PostgreSQL installed locally and `psql.exe` in your PATH to use `heroku pg:psql`.

### Common Database Commands

Check active connections:

```bash
heroku pg:ps -a your-app-name
```

View database size:

```bash
heroku pg:info -a your-app-name
```

Create a backup:

```bash
heroku pg:backups:capture -a your-app-name
```

Download latest backup:

```bash
heroku pg:backups:download -a your-app-name
```

Reset database (destructive!):

```bash
heroku pg:reset DATABASE_URL -a your-app-name --confirm your-app-name
```

**When to use these:**
- `pg:ps` - Debugging "too many connections" errors or finding slow queries
- `pg:info` - Checking if you're near database size limits
- `pg:backups:capture` - Before dangerous operations (data migrations, resets)
- `pg:reset` - When you need to completely wipe and recreate the database (development/staging only!)

### Database Debugging

**Symptom:** App crashes with "could not connect to database" error.

**Diagnosis steps:**

1. Check that DATABASE_URL is set:
   ```bash
   heroku config:get DATABASE_URL -a your-app-name
   ```
   **Expected:** A long PostgreSQL connection string starting with `postgres://`
   **If empty:** Database addon doesn't exist, run `heroku addons:create`

2. Verify Rails is configured for production:
   ```ruby
   # config/database.yml should have:
   production:
     url: <%= ENV['DATABASE_URL'] %>
   ```
   **Why:** Rails needs to be told to read DATABASE_URL. Older Rails versions required this explicitly.

3. Check if database addon exists:
   ```bash
   heroku addons -a your-app-name
   ```
   **Expected:** You should see `heroku-postgresql` in the list

4. Test connection manually:
   ```bash
   heroku pg:psql -a your-app-name
   ```
   **If this fails:** Database might be provisioning (wait a few minutes) or credentials are invalid (rotate them)

**Reference:**
- [Heroku Postgres](https://devcenter.heroku.com/articles/heroku-postgresql)
- [Managing Heroku Postgres with CLI](https://devcenter.heroku.com/articles/managing-heroku-postgres-using-cli)
- [Connecting to Heroku Postgres](https://devcenter.heroku.com/articles/connecting-heroku-postgres)

---

## Heroku Dashboard

### Logging Into the Dashboard

**Step 1: Go to the dashboard**

Open your browser and navigate to:

```
https://dashboard.heroku.com
```

**Step 2: Log in**

Use the same email and password you used when creating your Heroku account.

> [!TIP]
> If you logged in via `heroku login` in your terminal, you're authenticated there, but you still need to log into the web dashboard separately using your browser.

**Step 3: Find your app**

After logging in, you'll see a list of all your apps. Click on the app you want to inspect.

**Forgot your password?** Use the "Forgot password" link on the login page.

### Why Use the Dashboard?

The dashboard is a GUI alternative to CLI commands. It's useful for:
- Visual overview of app health
- Viewing build logs with syntax highlighting
- Managing config vars without memorizing commands
- Checking dyno status at a glance
- Quickly seeing which add-ons are provisioned

### Navigating the Dashboard

1. Go to [dashboard.heroku.com](https://dashboard.heroku.com)
2. Log in with your Heroku credentials
3. Select your app from the list
4. Navigate through tabs:
   - **Overview** - App status, recent activity, quick metrics
   - **Resources** - Dynos and add-ons (scale dynos here)
   - **Deploy** - Deployment methods and history (see what's deployed)
   - **Metrics** - Performance graphs (paid dynos only)
   - **Activity** - Build logs and releases (debugging deploy failures)
   - **Access** - Collaborators (who can access this app)
   - **Settings** - Config vars, domains, app info

### Viewing Build Logs

**Why build logs matter:** If your deploy fails, the error is in the build logs, not runtime logs. Common build failures:
- Missing gems
- Asset compilation errors
- Ruby version mismatches

**How to view:**
1. Go to the **Activity** tab
2. Click "View build log" next to any deployment
3. Check for errors in red

> [!TIP]
> Build failures often happen due to missing gems in production group, missing assets compilation, or incompatible Ruby/Rails versions.

### Common Dashboard Tasks

**Check dyno status:**
- Resources tab → See if dynos are "up" or "crashed"
- **If crashed:** Check logs for the error that caused the crash

**View add-ons:**
- Resources tab → Shows databases, logging, etc.
- Click on addon name to access its dashboard

**Manual database access:**
- Resources tab → Click on "Heroku Postgres" → "Dataclips" or "Settings"

---

## Environment Variables (Config Vars)

### Why Config Vars Exist

**Problem:** How do you store secrets (API keys, database passwords) without committing them to Git?

**Solution:** Environment variables. Heroku calls them "config vars."

**Key principles:**
- Config vars are **not** in your code
- They're **not** in Git
- They persist across deploys
- Changing them triggers an app restart

**Why this matters for debugging:** If your app can't connect to an external API or service, check that the required config vars are set.

### Understanding Config Vars

Config vars are Heroku's environment variables. They're available to your app as `ENV['VAR_NAME']` in Ruby.

View all config vars:

```bash
heroku config -a your-app-name
```

Get specific config var:

```bash
heroku config:get DATABASE_URL -a your-app-name
```

> [!IMPORTANT]
> Setting or removing a config var triggers an app restart and creates a new release.

**Why restart happens:** Your app code reads environment variables when it boots. To pick up new values, Heroku restarts your dynos.

### Setting Config Vars

Set single variable:

```bash
heroku config:set RAILS_MASTER_KEY=abc123 -a your-app-name
```

Set multiple variables:

```bash
heroku config:set \
  SECRET_KEY_BASE=xyz789 \
  RAILS_ENV=production \
  -a your-app-name
```

Unset a variable:

```bash
heroku config:unset SOME_VAR -a your-app-name
```

### Via Dashboard

1. Go to app **Settings** tab
2. Click "Reveal Config Vars"
3. Add KEY and VALUE
4. Click "Add"

**When to use CLI vs dashboard:**
- CLI: When scripting or setting multiple vars
- Dashboard: When you want to see all vars at once or copy/paste complex values

> [!TIP]
> For Rails apps, common config vars include:
> - `RAILS_MASTER_KEY` (for credentials.yml.enc)
> - `SECRET_KEY_BASE` (session security)
> - `RAILS_ENV` (usually `production`)
> - `RAILS_SERVE_STATIC_FILES` (set to `enabled` for asset serving)
> - `RAILS_LOG_TO_STDOUT` (should be `enabled`)

### Accessing in Rails

Config vars are available as environment variables:

```ruby
ENV['DATABASE_URL']
ENV['SECRET_KEY_BASE']
ENV.fetch('API_KEY')  # Raises error if not set
ENV.fetch('OPTIONAL_KEY', 'default_value')
```

**Why use `fetch` with a fallback:** If a required variable is missing, `fetch` raises an error immediately. This fails fast rather than silently using nil and breaking later.

### Local Development

**Problem:** You need different config vars locally than in production.

**Solution:** Create a `.env` file (don't commit it!):

```bash
echo ".env" >> .gitignore
```

```bash
# .env
DATABASE_URL=postgresql://localhost/myapp_dev
SECRET_KEY_BASE=local_dev_secret
```

Use with `heroku local`:

```bash
heroku local web
```

**What `heroku local` does:** Reads your `.env` file and Procfile, then runs your app locally with those environment variables. This simulates the Heroku environment.

**Reference:** [Configuration and Config Vars](https://devcenter.heroku.com/articles/config-vars)

---

## Git Remotes and Deployment

### Understanding Heroku Git Remotes

**How Heroku deployment works:**
1. You push code to a special Git remote
2. Heroku receives the code
3. Heroku runs buildpacks to install dependencies
4. Heroku starts your dynos with the new code

**Git remote:** A URL where Git can push/pull code. Think of it like a bookmark for a repository location.

**Why this matters:** If you can't deploy, it's often because the Git remote isn't configured correctly.

Heroku apps have a Git remote URL like:
```
https://git.heroku.com/your-app-name.git
```

When you create an app, Heroku adds a `heroku` remote automatically.

View remotes:

```bash
git remote -v
```

Example output:

```
heroku  https://git.heroku.com/your-app-name.git (fetch)
heroku  https://git.heroku.com/your-app-name.git (push)
origin  git@github.com:username/repo.git (fetch)
origin  git@github.com:username/repo.git (push)
```

**What you're seeing:**
- `origin` - Your GitHub repository (source of truth for your code)
- `heroku` - Your Heroku app (where you deploy)

### Adding a Remote Manually

If remote doesn't exist:

```bash
heroku git:remote -a your-app-name
```

With custom name:

```bash
heroku git:remote -a your-app-name -r production
```

Add remote directly:

```bash
git remote add heroku https://git.heroku.com/your-app-name.git
```

**When you need this:** If you're joining an existing project or cloned a repo that doesn't have the Heroku remote configured.

### Deploying

Push to deploy:

```bash
git push heroku main
```

**What happens:**
1. Git pushes your code to Heroku
2. Heroku detects it's a Ruby app (sees Gemfile)
3. Heroku runs the Ruby buildpack
4. Buildpack installs Ruby, runs `bundle install`, precompiles assets
5. Heroku starts your web dyno with the new code
6. Old dynos are shut down

Deploy from non-main branch:

```bash
git push heroku feature-branch:main
```

**Why the `:main` syntax:** Heroku always deploys the `main` branch on its side. `feature-branch:main` means "push my local `feature-branch` to Heroku's `main` branch."

> [!WARNING]
> Heroku always deploys to its `main` branch, regardless of your local branch name. Use `local-branch:main` syntax to deploy from other branches.

### Multiple Apps from Same Repo

**Common scenario:** You have staging and production apps, both running the same codebase.

**Why this is useful:** Test changes on staging before deploying to production.

Add staging remote:

```bash
git remote add staging https://git.heroku.com/your-app-staging.git
```

Add production remote:

```bash
git remote add production https://git.heroku.com/your-app-production.git
```

Deploy to staging:

```bash
git push staging main
```

Deploy to production:

```bash
git push production main
```

Run commands with multiple remotes:

```bash
heroku logs --app your-app-staging
heroku logs --app your-app-production
```

Or use remote names:

```bash
heroku logs --remote staging
heroku logs --remote production
```

> [!TIP]
> Rename default remote to be explicit:
> ```bash
> git remote rename heroku production
> ```
> This prevents accidentally deploying to production when you meant staging.

**Reference:**
- [Deploying with Git](https://devcenter.heroku.com/articles/git)
- [Managing Multiple Environments](https://devcenter.heroku.com/articles/multiple-environments)

---

## Deploying Different Rails App + DB to Same Container

> [!WARNING]
> This is **not recommended** for most cases. Heroku is designed for one app per dyno. Consider using separate Heroku apps for different applications.

**Why this is usually wrong:** Each Heroku app should be one application. If you need two apps, create two Heroku apps. This section covers replacing an app entirely.

However, if you must deploy a different app to an existing Heroku app:

### Step 1: Prepare New Rails App

Ensure new app has:

```ruby
# Gemfile
gem 'pg'  # Required for Heroku Postgres
```

```yaml
# config/database.yml
production:
  url: <%= ENV['DATABASE_URL'] %>
```

**Why:** Heroku provides Postgres, not SQLite. Your app must be configured to use Postgres in production.

### Step 2: Replace Git History (Destructive!)

```bash
# In your new Rails app directory
git init
git add .
git commit -m "New application"
```

### Step 3: Force Push to Heroku

```bash
# Add Heroku remote
heroku git:remote -a your-existing-app

# Force push (replaces everything)
git push heroku main --force
```

> [!DANGER]
> This **deletes** your previous app code and Git history on Heroku. Previous deployments cannot be rolled back. Make backups first!

**What `--force` does:** Normal git pushes require a linear history. Force push overwrites the remote history completely. Use with extreme caution.

### Step 4: Replace Database

**Why create a new database:** The new app likely has a different schema than the old app.

Create new database:

```bash
heroku addons:create heroku-postgresql:essential-0 -a your-app-name
```

This creates a new `DATABASE_URL`. Promote if needed:

```bash
heroku pg:promote HEROKU_POSTGRESQL_COLOR -a your-app-name
```

**What "promote" means:** If you have multiple databases, only one is the "primary" (used by DATABASE_URL). Promoting makes the new database primary.

Run migrations:

```bash
heroku run rails db:migrate -a your-app-name
```

Destroy old database (after confirming new one works):

```bash
heroku addons:destroy OLD_DATABASE_NAME -a your-app-name
```

### Alternative: Create New Heroku App

**Recommended approach** - create fresh app:

```bash
heroku create new-app-name
git push heroku main
heroku addons:create heroku-postgresql:essential-0
heroku run rails db:migrate
```

Then delete old app if needed:

```bash
heroku apps:destroy old-app-name --confirm old-app-name
```

**Why this is better:** Clean slate, no risk of config vars or remnants from old app causing issues.

---

## Debugging Methodology

### A Framework for Debugging Heroku Issues

**When something doesn't work, follow this process:**

#### Step 1: Reproduce the Error

Can you consistently trigger the error? If not, it might be intermittent (harder to debug).

#### Step 2: Check the Logs

```bash
heroku logs --tail -a your-app-name
```

**Look for:**
- Exception class and message
- Stack trace (shows which line of code failed)
- HTTP status codes (404, 500, 503, etc.)

#### Step 3: Determine Error Category

**Is it a build error or runtime error?**

**Build error (deploy fails):**
- Check Activity tab → View build log
- Common causes: missing gems, asset compilation, Ruby version

**Runtime error (app crashes after deploy):**
- Check runtime logs with `heroku logs`
- Common causes: missing config vars, database issues, code bugs

#### Step 4: Narrow Down the Scope

**Questions to ask:**
- Does it work locally? (If yes, it's environment-specific)
- Did it work before? (If yes, what changed?)
- Is it all requests or specific routes? (Helps isolate to specific code)

#### Step 5: Test Hypotheses

**Example hypothesis: "The database isn't connected"**

**How to test:**
```bash
heroku pg:info -a your-app-name
heroku config:get DATABASE_URL -a your-app-name
heroku run rails console -a your-app-name
# In console: ActiveRecord::Base.connection
```

**If database connects:** Hypothesis wrong, try next one

**Example hypothesis: "A required gem is missing"**

**How to test:**
```bash
heroku run bundle list -a your-app-name | grep gem-name
```

#### Step 6: Make One Change at a Time

Change one thing, deploy, test. Don't change five things at once - you won't know which fixed it.

### Common Debugging Patterns

**Pattern 1: "It works locally but not on Heroku"**

**Why:** Environment differences. Check:
- Are you using SQLite locally but Postgres on Heroku?
- Are config vars set on Heroku?
- Did assets compile?

**Pattern 2: "It worked, then I deployed and it broke"**

**Why:** You introduced a bug or configuration issue. Check:
- What changed in the latest commit?
- Did you add a new gem that needs config vars?
- Did you run migrations?

**Pattern 3: "The build succeeds but the app crashes immediately"**

**Why:** The app starts but hits an error during boot. Check logs for:
- Missing config vars (SECRET_KEY_BASE, etc.)
- Database connection errors
- Gem compatibility issues

---

## Common Issues & Solutions

### App Crashed After Deploy

**Symptom:** Visiting your app shows "Application Error"

**Check logs:**

```bash
heroku logs --tail -a your-app-name
```

**Common causes:**

#### 1. Missing environment variables

**How to diagnose:**
```bash
heroku config -a your-app-name
```

**Look for:** Missing RAILS_MASTER_KEY, SECRET_KEY_BASE, etc.

**Fix:**
```bash
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key) -a your-app-name
```

**Why this happens:** Rails 5.2+ uses encrypted credentials. Without the master key, Rails can't decrypt credentials.yml.enc and crashes.

#### 2. Database not migrated

**How to diagnose:** Error in logs mentions "relation does not exist" or "undefined table"

**Fix:**
```bash
heroku run rails db:migrate -a your-app-name
```

**Why this happens:** You added a migration locally but forgot to run it on Heroku.

#### 3. Missing gems in production

**How to diagnose:** Error mentions "cannot load such file" or gem name

**Check Gemfile:** Is the gem in `development` or `test` group?

**Fix:** Move gem outside these groups or to `production` group

**Why this happens:** Heroku runs `bundle install --without development:test`, so gems in those groups aren't installed.

#### 4. Asset precompilation failed

**How to diagnose:** Build logs show asset compilation errors

**Common causes:**
- JavaScript errors in asset files
- Missing Node.js buildpack
- CSS compilation errors

**Fix:**
```bash
heroku buildpacks:add --index 1 heroku/nodejs -a your-app-name
```

**Why:** Rails asset pipeline often needs Node.js to compile JavaScript/CSS.

### Cannot Connect to Database

**Symptom:** Error in logs: "could not connect to server" or "database does not exist"

**Step-by-step diagnosis:**

```bash
# Check if Postgres addon exists
heroku addons -a your-app-name
```

**Expected:** See `heroku-postgresql`
**If missing:**
```bash
heroku addons:create heroku-postgresql:essential-0 -a your-app-name
```

```bash
# Check DATABASE_URL is set
heroku config:get DATABASE_URL -a your-app-name
```

**Expected:** Long postgres:// URL
**If empty:** Database addon isn't attached properly, try removing and re-adding

```bash
# Test connection
heroku pg:psql -a your-app-name
```

**Expected:** SQL prompt
**If fails:** Database credentials rotated or network issue

**Why database connection fails:** Usually DATABASE_URL is missing/wrong, or Rails isn't configured to read it.

### Slow or Timing Out

**Symptom:** Requests take forever or timeout with H12 error

**Check dyno status:**

```bash
heroku ps -a your-app-name
```

**If crashed:** Fix the crash first (see above)

**Restart dynos:**

```bash
heroku restart -a your-app-name
```

**Check for memory issues:**

```bash
heroku logs --source heroku --tail -a your-app-name
```

**Look for:** R14 errors (memory quota exceeded)

**Why timeout happens:**
- Slow database queries (optimize with indexes)
- External API calls taking too long (add timeout)
- Memory issues causing swapping
- Free dyno asleep (first request wakes it up)

### Assets Not Loading

**Symptom:** CSS/JS not loading, 404 errors for assets

**Ensure these settings:**

```ruby
# config/environments/production.rb
config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
```

**Set config var:**

```bash
heroku config:set RAILS_SERVE_STATIC_FILES=enabled -a your-app-name
```

**Why this is needed:** In production, Rails defaults to NOT serving static files (expects nginx/CDN to do it). On Heroku without a CDN, Rails must serve them.

**Alternative fix:** Use a CDN (CloudFront, Cloudflare) and set `config.asset_host`

### Build Failing

**Where to look:** Activity tab in dashboard → View build log

**Common issues:**

#### Ruby version mismatch

**Error in build log:** "Ruby version X is not available"

**Fix:** Update `Gemfile` to specify correct version:
```ruby
ruby '3.2.0'
```

**Why:** Heroku needs to know which Ruby version to install.

#### Node.js required but missing

**Error in build log:** "node: command not found"

**Fix:** Add buildpacks in correct order:
```bash
heroku buildpacks:add heroku/nodejs -a your-app-name
heroku buildpacks:add heroku/ruby -a your-app-name
```

**Why:** Asset compilation needs Node.js. Buildpacks run in order, so Node.js must be first.

#### Bundler version mismatch

**Error in build log:** "Your bundle is locked to bundler X but you're using Y"

**Fix:** Regenerate Gemfile.lock with correct bundler:
```bash
gem install bundler -v X.Y.Z
bundle install
git add Gemfile.lock
git commit -m "Update Gemfile.lock"
```

**Why:** Gemfile.lock records which bundler version was used. Heroku installs that version.

**Reference:** [Troubleshooting Heroku Deployments](https://devcenter.heroku.com/articles/error-codes)

---

## Additional Topics

### Topics to Explore Next

**For students who master the basics:**

1. **Database management:**
   - Seeding production safely
   - Importing/exporting with pg:backups
   - Running migrations without downtime
   - [Import/Export Guide](https://devcenter.heroku.com/articles/heroku-postgres-import-export)

2. **Performance optimization:**
   - Understanding dyno types
   - Scaling with `ps:scale`
   - Memory profiling
   - [Dyno Types](https://devcenter.heroku.com/articles/dyno-types)

3. **CI/CD:**
   - GitHub integration for auto-deploy
   - Review apps for PRs
   - [GitHub Integration](https://devcenter.heroku.com/articles/github-integration)

4. **Security:**
   - Managing credentials properly
   - SSL enforcement
   - Dependency updates

5. **Rails-specific gotchas:**
   - SQLite vs Postgres differences
   - Ephemeral filesystem (use S3 for uploads)
   - ActionCable on Heroku
   - Background jobs with Sidekiq

### Key Heroku Limitations to Remember

1. **Free dynos sleep after 30 min inactivity** - First request is slow
2. **Ephemeral filesystem** - Files disappear on restart
3. **1,500 log lines max** - Use add-on for more
4. **30-second request timeout** - Requests must complete fast
5. **512 MB RAM on free dynos** - Easy to exceed with memory leaks

---

## Quick Reference Card

### Emergency Debugging Checklist

1. ✅ Check if app is running: `heroku ps -a app-name`
2. ✅ Check logs: `heroku logs --tail -a app-name`
3. ✅ Check config vars: `heroku config -a app-name`
4. ✅ Check database: `heroku pg:info -a app-name`
5. ✅ Check recent changes: Activity tab in dashboard
6. ✅ Try restarting: `heroku restart -a app-name`
7. ✅ Run migrations: `heroku run rails db:migrate -a app-name`

### Most Common Commands

```bash
heroku logs --tail -a app-name          # Watch logs
heroku run rails console -a app-name    # Open console
heroku run rails db:migrate -a app-name # Run migrations
heroku config:set KEY=value -a app-name # Set env var
heroku restart -a app-name              # Restart app
heroku pg:psql -a app-name              # Database console
git push heroku main                    # Deploy
```

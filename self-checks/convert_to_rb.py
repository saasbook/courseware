import json, os

if __name__ == '__main__':
    # Create Module Directories
    curr_dir = os.getcwd()
    for x in range(1, 13):
        folderName = "module"+str(x)
        final_dir = os.path.join(curr_dir, folderName)
        if not os.path.exists(final_dir):
           os.makedirs(final_dir)

    # Load JSON data of Self Check Questions
    with open('self-checks.json') as f:
        data = json.load(f)

    for module in data:
        # Create Quiz File
        title = module["module"].encode('utf-8')
        mod, submod = title.split(":", 1)[0].split(".")
        filename = "sc"+mod+"-"+submod+'.rb'
        quiz = open(filename, 'w+')

        # Begin Quiz Block
        quiz.write("quiz \"" + title +"\" do\n")

        # Add Question to Block
        for question in module["questions"]:
            quiz.write("\tchoice_answer do\n")

            # Write Question Text
            text = question["text"].encode('utf-8')
            quiz.write("\t\ttext \"" + text + "\"\n")

            for answer in question["answer"]:
                text = answer["answer_text"].encode('utf-8')
                if answer["answer_weight"] == 1:
                    quiz.write("\t\tanswer \"")
                elif answer["answer_weight"] == 0:
                    quiz.write("\t\tdistractor \"")
                quiz.write(text + "\"\n")

            # Add Explanation to Block
            explain = question["explanation"].encode('utf-8')
            quiz.write("\t\texplanation \"" + explain + "\"\n")
            quiz.write("\tend\n")

        # End Quiz Block
        quiz.write("end")

        # Move quiz into corresponding module folder
        curr_path = curr_dir+"/"+filename
        new_path = curr_dir+"/module"+str(mod)+"/"+filename
        os.rename(curr_path, new_path)

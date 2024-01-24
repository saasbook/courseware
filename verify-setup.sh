#! /usr/bin/env bash

quit() {
    echo "NO: "$1
    exit 1
}

check_bash() {
    ## is bash the current shell?

    echo -n 'Checking if bash is the shell...'
    if [[ `echo $SHELL` = *'bash' ]] || [[ `echo $SHELL` = *'zsh' ]] || [[ `echo $SHELL` = *'csh' ]]; then
        echo "OK"
    else
        quit "it's not"
    fi
}

check_curl() {
    echo -n 'Checking if curl is installed...'
    if [[ `curl --version` = 'curl '* ]]; then
        echo 'OK'
    else
        quit 'cURL is not installed. See the assignment for options.'
    fi
}
 
check_git() {
    ## is git installed?

    echo -n 'Checking if Git CLI is installed...'
    if [[ `git status /tmp 2>&1` = *fatal* ]]; then
        echo "OK"
    else
        quit "Git CLI not installed"
    fi
}

check_git_ssh() {
    ## is git configured?

    echo -n 'Checking Git ssh access...'
    if [[ `ssh -T git@github.com 2>&1` = *'successfully authenticated'* ]]; then
        echo "OK"
    else
        quit "git is installed, but `ssh -T git@github.com` fails."
    fi
}

check_rvm_ruby() {
    ## is there a recent ruby version using rvm?

    echo -n 'Checking for recent rvm-installed Ruby version...'
    rubies=`rvm list 2>&1`
    if [[ $rubies = *'not found'* ]]; then
        quit "rvm is not installed or not in the $PATH"
    elif [[ $rubies = *'2.'* ]] || [[ $rubies = *'3.'* ]]; then
        echo "OK"
    else
        quit "rvm is installed, but you need Ruby 2.6.x or 2.7.x"
    fi
}

check_rails() {
    ## is Rails 6 installed?
    source $HOME/.rvm/scripts/rvm
    echo -n 'Checking for Rails 6.x...'
    if [[ `rvm use ; gem list -i rails -v '~> 6'` = *'true' ]]; then
        echo "OK"
    else
        quit "you need to \`rvm use <ruby-version>\` then \`gem install rails -v '~> 6'\`"
    fi
}

check_node() {
    ## is Node.js installed?
    echo -n 'Checking for node.js and npm...'
    if [[ `node -v 2>&1` = 'v'* ]]; then
        if [[ `npm -v 2>&1` ]]; then
            echo 'OK'
        else
            echo 'Node is installed, but npm does not appear to be!'
        fi
    else
        quit 'Node/NPM are not installed. See nodejs.org for instructions.'
    fi
}

check_heroku() {
    ## is Heroku CLI installed?
    source $HOME/.rvm/scripts/rvm
    echo -n "Checking for Heroku CLI..."
    if [[ $(heroku --version | sed 's/heroku\/\([[:digit:]]\).*/\1/') -ge 7 ]]; then
        echo "OK"
    else
        quit "Heroku CLI >=7.0.0 is not installed. See devcenter.heroku.com/articles/heroku-cli"
    fi
}

check_heroku_login() {
    source $HOME/.rvm/scripts/rvm
    echo -n 'Checking Heroku login...'
    if [[ `rvm use ; heroku apps 2>&1` = *'==='*'Apps'* ]]; then
        echo 'OK'
    else
        quit 'Heroku CLI installed, but you must use `heroku login` to authenticate'
    fi
}

if [[ $1 != '' ]]; then
    check_$1 ; exit 0
else
    for thing in bash curl git git_ssh rvm_ruby rails node heroku heroku_login
    do
        check_$thing
    done
    echo "Congratulations! You're good to go."
fi


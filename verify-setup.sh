#! /usr/bin/env bash

quit() {
    echo "NO: "$1
    exit 1
}

pass() {
    echo "✅ $1"
    return 0
}

fail() {
    echo "❌ $1"
    return -1
}

check_bash() {
    ## is bash the current shell?

    echo -n 'Checking if bash is the shell...'
    if [[ `echo $SHELL` = *'bash' ]] || [[ `echo $SHELL` = *'zsh' ]] || [[ `echo $SHELL` = *'csh' ]]; then
        pass "OK"
    else
        quit "it's not"
    fi
}

check_curl() {
    echo -n 'Checking if curl is installed...'
    if [[ `curl --version` = 'curl '* ]]; then
        echo "OK"
    else
        quit 'cURL is not installed. See the assignment for options.'
    fi
}

check_git() {
    ## is git installed?

    echo -n 'Checking if Git CLI is installed...'
    if [[ `git status /tmp 2>&1` = *fatal* ]]; then
        pass "OK"
    else
        quit "Git CLI not installed"
    fi
}

check_git_ssh() {
    ## is git configured?
    echo -n 'Checking Git ssh access...'
    if [[ `ssh -T git@github.com 2>&1` = *'successfully authenticated'* ]]; then
        pass "OK"
    else
        quit "git is installed, but `ssh -T git@github.com` fails."
    fi
}

check_rvm_ruby() {
    ## is there a recent ruby version using rvm?
    echo -n 'Checking for recent rvm-installed Ruby version...'
    rubies=`rvm list 2>&1`
    if [[ $rubies = *'not found'* ]]; then
        fail "rvm is not installed or not in you PATH"
    elif [[ $rubies = *'2.'* ]] || [[ $rubies = *'3.'* ]]; then
        pass "rvm is installed"
        return 0;
    else
        fail "rvm is installed, but you need Ruby 2.6.x or 2.7.x"
    fi
}

check_asdf() {
    echo -n 'Checking if asdf is installed...'
    # TODO: Check asdf plugins to see if Ruby is installed
    if command -v asdf >/dev/null 2>&1; then
        pass "asdf is installed";
        return 0;
    else
        fail "asdf is not installed. See https://asdf-vm.com/ for instructions."
    fi
}

check_mise() {
    echo -n 'Checking if mise is installed...'
    if command -v mise >/dev/null 2>&1; then
        pass "mise is installed"
        return 1;
    else
        fail "mise is not installed."
    fi
}

check_ruby_version() {
    echo -n 'Checking if Ruby is set up correctly...'
    if [[ `ruby -v` = *'ruby '* ]]; then
        pass "Ruby is set up correctly"
    else
        fail "Ruby is not set up correctly."
    fi
}

check_version_manager() {
    if check_rvm_ruby || check_asdf || check_mise; then
        pass "One of rvm, asdf, or mise is set up"
    else
        echo "You should have a version manager in your PARTH"
        echo "We recommend using rvm, asdf, or mise"
        echo $PATH
        quit "None of rvm, asdf, or mise is set up. Please install one of them."
    fi
}

check_rails() {
    ## is Rails 6 installed?
    # source $HOME/.rvm/scripts/rvm
    echo -n 'Checking for Rails 6.x...'
    if [[ `gem list -i rails -v '~> 6'` = *'true' ]]; then
        pass "OK"
    else
        quit "you need to setup Ruby 3.0+ then \`gem install rails -v '~> 6'\`"
    fi
}

check_node() {
    ## is Node.js installed?
    echo -n 'Checking for node.js and npm...'
    if [[ `node -v 2>&1` = 'v'* ]]; then
        if [[ `npm -v 2>&1` ]]; then
            echo "OK"
        else
            echo 'Node is installed, but npm does not appear to be!'
        fi
    else
        quit 'Node/NPM are not installed. See nodejs.org for instructions.'
    fi
}

check_heroku() {
    ## is Heroku CLI installed?
    # source $HOME/.rvm/scripts/rvm
    echo -n "Checking for Heroku CLI..."
    if [[ $(heroku --version | sed -E 's/^heroku\/([0-9]+)\..*/\1/') -ge 7 ]]; then
        pass "OK"
    else
        quit "Heroku CLI >=7.0.0 is not installed. See devcenter.heroku.com/articles/heroku-cli"
    fi
}

check_heroku_login() {
    # source $HOME/.rvm/scripts/rvm
    echo -n 'Checking Heroku login...'
    if [[ `heroku apps 2>&1` = *'==='*'Apps'* ]]; then
        echo "OK"
    else
        quit 'Heroku CLI installed, but you must use `heroku login` to authenticate'
    fi
}

if [[ $1 != '' ]]; then
    check_$1 ; exit 0
else
    for thing in bash curl git git_ssh version_manager ruby_version rails node heroku heroku_login
    do
        check_$thing
    done
    echo "🎉 Congratulations! You're good to go."
fi

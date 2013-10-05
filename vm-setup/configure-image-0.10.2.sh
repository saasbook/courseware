#!/bin/bash
# Note: you will be prompted to enter the password several times through the script
# run with . setup_part_1.sh

# This script is designed for Ubuntu 11.10

cd ~/
sudo apt-get update
sudo apt-get install -y dkms     # For installing VirtualBox guest additions

# Install RVM and ruby 1.9.3 note: may take a while to compile ruby
sudo apt-get install -y curl
\curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3
source ~/.rvm/scripts/rvm


# Install sqlite3 dev
sudo apt-get -y install sqlite3 libsqlite3-dev

# Install nodejs
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs

# Install jslint
cd ~/
curl -LO http://www.javascriptlint.com/download/jsl-0.3.0-src.tar.gz
tar -zxvf jsl-0.3.0-src.tar.gz
cd jsl-0.3.0/src/
make -f Makefile.ref
cd ~/
sudo cp jsl-0.3.0/src/Linux_All_DBG.OBJ/jsl /usr/local/bin
sudo rm jsl-0.3.0-src.tar.gz
sudo rm -rf ~/jsl-0.3.0

# Install other programs
sudo apt-get install -y git
sudo apt-get install -y chromium-browser
sudo apt-get install -y graphviz
sudo apt-get install -y libpq-dev


## Editors
# Install VIM and add some basic config/plugins
sudo apt-get install -y vim
echo "filetype on  \" Automatically detect file types." >> .vimrc
echo "set nocompatible  \" no vi compatibility." >> .vimrc
echo "" >> .vimrc
echo "\" Add recently accessed projects menu (project plugin)" >> .vimrc
echo "set viminfo^=\!" >> .vimrc
echo "" >> .vimrc
echo "\" Minibuffer Explorer Settings" >> .vimrc
echo "let g:miniBufExplMapWindowNavVim = 1" >> .vimrc
echo "let g:miniBufExplMapWindowNavArrows = 1" >> .vimrc
echo "let g:miniBufExplMapCTabSwitchBufs = 1" >> .vimrc
echo "let g:miniBufExplModSelTarget = 1" >> .vimrc
echo "" >> .vimrc
echo "\" alt+n or alt+p to navigate between entries in QuickFix" >> .vimrc
echo "map <silent> <m-p> :cp <cr>" >> .vimrc
echo "map <silent> <m-n> :cn <cr>" >> .vimrc
echo "" >> .vimrc
echo "\" Change which file opens after executing :Rails command" >> .vimrc
echo "let g:rails_default_file='config/database.yml'" >> .vimrc
echo "" >> .vimrc
echo "syntax enable" >> .vimrc
echo "" >> .vimrc
echo "set cf  \" Enable error files & error jumping." >> .vimrc
echo "set clipboard+=unnamed  \" Yanks go on clipboard instead." >> .vimrc
echo "set history=256  \" Number of things to remember in history." >> .vimrc
echo "set autowrite  \" Writes on make/shell commands" >> .vimrc
echo "set ruler  \" Ruler on" >> .vimrc
echo "set nu  \" Line numbers on" >> .vimrc
echo "set nowrap  \" Line wrapping off" >> .vimrc
echo "set timeoutlen=250  \" Time to wait after ESC (default causes an annoying delay)" >> .vimrc
echo "\" colorscheme vividchalk  \" Uncomment this to set a default theme" >> .vimrc
echo "" >> .vimrc
echo "\" Formatting" >> .vimrc
echo "set ts=2  \" Tabs are 2 spaces" >> .vimrc
echo "set bs=2  \" Backspace over everything in insert mode" >> .vimrc
echo "set shiftwidth=2  \" Tabs under smart indent" >> .vimrc
echo "set nocp incsearch" >> .vimrc
echo "set cinoptions=:0,p0,t0" >> .vimrc
echo "set cinwords=if,else,while,do,for,switch,case" >> .vimrc
echo "set formatoptions=tcqr" >> .vimrc
echo "set cindent" >> .vimrc
echo "set autoindent" >> .vimrc
echo "set smarttab" >> .vimrc
echo "set expandtab" >> .vimrc
echo "" >> .vimrc
echo "\" Visual" >> .vimrc
echo "set showmatch  \" Show matching brackets." >> .vimrc
echo "set mat=5  \" Bracket blinking." >> .vimrc
echo "set list" >> .vimrc
echo "\" Show $ at end of line and trailing space as ~" >> .vimrc
echo "set lcs=tab:\ \ ,eol:$,trail:~,extends:>,precedes:<" >> .vimrc
echo "set novisualbell  \" No blinking ." >> .vimrc
echo "set noerrorbells  \" No noise." >> .vimrc
echo "set laststatus=2  \" Always show status line." >> .vimrc
echo "" >> .vimrc
echo "\" gvim specific" >> .vimrc
echo "set mousehide  \" Hide mouse after chars typed" >> .vimrc
echo "set mouse=a  \" Mouse in all modesc" >> .vimrc
mkdir .vim
cd .vim
wget http://www.vim.org/scripts/download_script.php?src_id=16429
mv d* rails.zip
unzip rails.zip
rm -rf rails.zip
# to allow :help rails, start up vim and type :helptags ~/.vim/doc

# Install emacs and add some basic config/plugins
cd ~/
sudo apt-get install -y emacs
wget https://github.com/downloads/magit/magit/magit-1.1.1.tar.gz
tar -zxvf magit-1.1.1.tar.gz
cd magit-1.1.1/
make
sudo make install
echo "(require 'magit)" >> .emacs
cd ~/
rm -rf magit-1.1.1/ magit-1.1.1.tar.gz
cd /usr/share/emacs
sudo mkdir includes
cd includes
sudo wget http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/trunk/misc/ruby-mode.el
sudo wget http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/trunk/misc/ruby-electric.el
cd ~/
echo "" >> .emacs
echo "; directory to put various el files into" >> .emacs
echo "; (add-to-list 'load-path \"/usr/share/emacs/includes\")" >> .emacs
echo "" >> .emacs
echo "(global-font-lock-mode 1)" >> .emacs
echo "(setq font-lock-maximum-decoration t)" >> .emacs
echo "" >> .emacs
echo "; loads ruby mode when a .rb file is opened." >> .emacs
echo "(autoload 'ruby-mode \"ruby-mode\" \"Major mode for editing ruby scripts.\" t)" >> .emacs
echo "(setq auto-mode-alist  (cons '(\".rb$\" . ruby-mode) auto-mode-alist))" >> .emacs
echo "(setq auto-mode-alist  (cons '(\".rhtml$\" . html-mode) auto-mode-alist))" >> .emacs
echo "" >> .emacs
echo "(add-hook 'ruby-mode-hook" >> .emacs
echo "        (lambda()" >> .emacs
echo "          (add-hook 'local-write-file-hooks" >> .emacs
echo "                  	'(lambda()" >> .emacs
echo "                     	(save-excursion" >> .emacs
echo "                       	(untabify (point-min) (point-max))" >> .emacs
echo "                       	(delete-trailing-whitespace)" >> .emacs
echo "                       	)))" >> .emacs
echo "        	(set (make-local-variable 'indent-tabs-mode) 'nil)" >> .emacs
echo "        	(set (make-local-variable 'tab-width) 2)" >> .emacs
echo "        	(imenu-add-to-menubar \"IMENU\")" >> .emacs
echo "        	(define-key ruby-mode-map \"\C-m\" 'newline-and-indent)" >> .emacs
echo "        	(require 'ruby-electric)" >> .emacs
echo "        	(ruby-electric-mode t)" >> .emacs
echo "        	))" >> .emacs


## GEMS

# install rails 3.2.13
gem install rails -v 3.2.13

# sqlite 3 gem
gem install sqlite3-ruby

# other gems
gem install cucumber -v 1.3.2
gem install cucumber-rails -v 1.0.0
gem install cucumber-rails-training-wheels
gem install rspec
gem install autotest
gem install spork
gem install metric_fu
gem install debugger
gem install timecop -v 0.6.1
gem install chronic -v 0.9.1
gem install omniauth
gem install omniauth-twitter
gem install nokogiri
gem install ruby-tmdb -v 0.2.1
gem install ruby-graphviz
gem install reek
gem install flog
gem install flay
rvm 1.9.3 do gem install jquery-rails
gem install fakeweb

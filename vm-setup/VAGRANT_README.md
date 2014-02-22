    <h1>Introduction</h1>
    <p>
        Vagrant designed to run through multiple platforms including currently Mac OS X, Microsoft Windows, Debian, Ubuntu, CentOS, RedHat and Fedora, in this document we will handle how to configure and run virtual development environment through Vagrant from scratch to up and running, on Ubuntu and Windows environments.
    </p>
    <h1>1) Ubuntu Environment</h1>
    <p>
        To configure Vagrant inside Ubuntu environment, we should to follow the following sections
        <ul>
            <li>Installing Vagrant</li>
            <li>Create Vagrant Machine Folders</li>
            <li>Installing Precise32 Box</li>
            <li>Creating New Virtual Machine</li>
            <li>Downliading Virtual Machine</li>
            <li>Configuration Script Shell</li>
            <li>Configuring Permissions for Virtual Machine Configuration Script Shell</li>
        </ul>
    </p>
    <h2>Installing Vagrant</h2>
    <p>
        First thing, you need to install vagrant packages from advanced packaging tool apt-get.<br />
        This will require you to enter your password, enter it and confirm to download.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~$<b>sudo apt-get install vagrant</b><br />
                [sudo] password for administrator:<br />
                Reading package lists... Done<br />
                Building dependency tree<br />
                Reading state information... Done<br />
                The following extra packages will be installed:<br />
                bsdtar curl dkms libgsoap3 libruby1.9.1 libsdl1.2debian libyaml-0-2 ruby<br />
                ruby-childprocess ruby-erubis ruby-ffi ruby-i18n ruby-log4r ruby-net-scp<br />
                ruby-net-ssh ruby1.9.1 virtualbox virtualbox-dkms virtualbox-qt<br />
                Suggested packages:<br />
                bsdcpio debhelper ri ruby-dev ruby1.9.1-examples ri1.9.1 graphviz<br />
                ruby1.9.1-dev ruby-switch virtualbox-guest-additions-iso vde2<br />
                The following NEW packages will be installed:<br />
                bsdtar curl dkms libgsoap3 libruby1.9.1 libsdl1.2debian libyaml-0-2 ruby<br />
                ruby-childprocess ruby-erubis ruby-ffi ruby-i18n ruby-log4r ruby-net-scp<br />
                ruby-net-ssh ruby1.9.1 vagrant virtualbox virtualbox-dkms virtualbox-qt<br />
                0 upgraded, 20 newly installed, 0 to remove and 11 not upgraded.<br />
                Need to get 25.2 MB of archives.<br />
                After this operation, 94.8 MB of additional disk space will be used.<br />
                Do you want to continue [Y/n]? <b>Y</b><br />
            </td>
        </tr>
    </table>
    <h2>Create Vagrant Machine Folders</h2>
    <p>
        Folders could be created based on your choice; in our case, we will create the following folder in the home folder:
    </p>
    <p>Vagrant -&gt; Projects -&gt; VM_169.x</p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~$<b>mkdir Vagrant</b><br />
                administrator@host01:~$<b>mkdir Vagrant/Projects</b><br />
                administrator@host01:~$<b>mkdir Vagrant/Projects/VM_169.x</b><br />
                administrator@host01:~$<b>cd ~/Vagrant/Projects/VM_169.x</b><br />
                administrator@host01:~/Vagrant/Projects/VM_169.x$<br/>
            </td>
        </tr>
    </table>
    <h2>Installing Precise32 Box</h2>
    <p>
        Vagrant provides many ready-made boxes, in our case; we will use the ready-made box called precise32, we need to download and install precise32 box in our vagrant installation.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant box add precise32 http://files.vagrantup.com/precise32.box --provider virtualbox</b><br />
                Downloading or copying the box...<br />
                Extracting box...te: 5410k/s, Estimated time remaining: --:--:--)<br />
                Successfully added box 'precise32' with provider 'virtualbox'!<br />
            </td>
        </tr>
    </table>
    <p>
        To validate our installation, we should to check the list of installed boxes.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant box list</b><br />
                precise32 (virtualbox)<br />
            </td>
        </tr>
    </table>
    <h2>Creating New Virtual Machine</h2>
    <p>
        We should initialize new virtual machine for our usage based on the precise32 box we installed earlier, from the folder already created for this virtual machine VM_169.x, we should initialize the virtual machine there.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant init precise32</b><br />
                A `Vagrantfile` has been placed in this directory. You are now<br />
                ready to `vagrant up` your first virtual environment! Please read<br />
                the comments in the Vagrantfile as well as documentation on<br />
                `vagrantup.com` for more information on using Vagrant.<br />
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>ls</b><br />
                Vagrantfile<br />
            </td>
        </tr>
    </table>
    <p>
        Initializing virtual machine here means vagrant will create new vagrant file in this folder called Vagrantfile, this file will contain any custom settings you want to add on the virtual machine like amount of memory, networking, shared folders, settings … Anything specified here will override the defaults.
    </p>
    <h2>Downloading Virtual Machine Configuration Script Shell</h2>
    <p>
        We need to download this file to execute it inside the newly created virtual machine, currently we have file version configure-image-0.10.3.sh, and we will download it directly inside the virtual machine folder in the host so it will be already shared inside our guest virtual machine.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>wget https://raw.github.com/saasbook/courseware/master/vm-setup/configure-image-0.10.3.sh</b>
            </td>
        </tr>
    </table>
    <h2>Configuring Permissions for Virtual Machine Configuration Script Shell</h2>
    <p>
        Before executing the configuration script shell, it requires giving it proper permissions; else, we will face many errors during script execution, we need specifically the permission to execute or run the file as a program, this permission will be given through the following command.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>chmod +x configure-image-0.10.3.sh</b>
            </td>
        </tr>
    </table>
    <h2>Running the Virtual Machine</h2>
    <p>
        Now is the time to run the created virtual machine for first time.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant up</b><br />
                Bringing machine 'default' up with 'virtualbox' provider...<br />
                [default] Importing base box 'precise32'...<br />
                [default] Matching MAC address for NAT networking...<br />
                [default] Setting the name of the VM...<br />
                [default] Clearing any previously set forwarded ports...<br />
                [default] Creating shared folders metadata...<br />
                [default] Clearing any previously set network interfaces...<br />
                [default] Preparing network interfaces based on configuration...<br />
                [default] Forwarding ports...<br />
                [default] -- 22 =&gt; 2222 (adapter 1)<br />
                [default] Booting VM...<br />
                [default] Waiting for VM to boot. This can take a few minutes.<br />
                [default] VM booted and ready for use!<br />
                [default] Configuring and enabling network interfaces...<br />
                [default] Mounting shared folders...<br />
                [default] -- /vagrant<br />
            </td>
        </tr>
    </table>
    <p>
        By default it forward the port 22 (ssh) to port 2222 and mounts the shared folder where the virtual machine located VM_169.x to /vagrant in the virtual machine.
    </p>
    <h2>Connecting to the Virtual Machine</h2>
    <p>
        Let’s start to use our new virtual machine, first we need to connect through ssh, it will open a ssh console to the virtual.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant ssh</b><br />
                Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)<br />
                <br />
                * Documentation:  https://help.ubuntu.com/<br />
                Welcome to your Vagrant-built virtual machine.<br />
                Last login: Fri Sep 14 06:22:31 2012 from 10.0.2.2<br />
                vagrant@precise32:~$<br />
            </td>
        </tr>
    </table>
    <h2>Running the Virtual Machine Configuration Script Shell</h2>
    <p>
        We need to configure virtual machine to make it ready for course work; this will be through running the configuration script inside the newly created virtual machine, it will just ask you about your account’s password to be used during configuration and just wait to finish, it will take some time to finish.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                vagrant@precise32:~$ <b>/vagrant/configure-image-0.10.3.sh</b><br />
                Enter password to be used for sudo commands:<b>vagrant</b><br />
            </td>
        </tr>
    </table>
    <h2>Suspending and Shutting Down Virtual Machine</h2>
    <p>
        After you finish your working, you need either to suspend and resume your virtual machine or turn it off; you can use one of the following commands upon your choice.
    </p>
    <table style='font-size:small;font-family:"Courier New";border:1px solid black'>
        <tr>
            <td>
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant suspend</b><br />
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant resume</b><br />
                administrator@host01:~/Vagrant/Projects/VM_169.x$ <b>vagrant halt</b><br />
            </td>
        </tr>
    </table>

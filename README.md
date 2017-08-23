# DrupalBox

DrupalBox is a template Drupal project that can be used to seed
(create) a new Drupal project quickly and easily.

The new project will contain:
- A Drupal profile.
- Makefiles for downloading the Drupal core, all the needed modules,
  libraries, patches, etc.
- Docker scripts for installing an Ubuntu server with all the packages
  and configurations needed for running a Drupal application.


## Create a new project

A new project is created by renaming files of the template project and
doing find/replace in them.

    ### clone fro github
    git clone https://github.com/docker-scripts/dbox
    cp -a dbox myproject
    cd myproject/
    
    ### rename the project
    ./rename-project.sh  # see usage
    ./rename-project.sh btr_server:myproject btr:proj
    
    ### create a git repo
    git init .
    git add .
    git commit -m 'Initial commit.'
    
    ### upload to github
    git remote add origin https://github.com/<username>/myproject.git
    git push -u origin master

The script `rename-project.sh` works by renaming files of the template
project and doing find/replace in them. There are two parameters that
are used to customize the template project: the *project name* and the
*project prefix*. In the template project they are represented by
*btr_server* and *btr*, which are then replaced in the new project by the
new project’s name and prefix.

Why these strange names? Why not use something like *example* and
*xmp*, or *sample* and *smp*, or *template* and *tmp* etc.

The main reason is exactly that they are strange names and so there is
no risk of collision with other names used in a project. For example
*xmp* or *template* or *tmp* maybe are used on the project for
something else as well, and replacing them blindly with a new value
may break the application.


## Install the new project

  - First install Docker:
    https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

  - Then install `ds` and `wsproxy`:
     + https://github.com/docker-scripts/ds#installation
     + https://github.com/docker-scripts/wsproxy#installation


  - Get the code of `myproject` from GitHub, like this:
    ```
    git clone https://github.com/dashohoxha/myproject /opt/docker-scripts/myproject
    ```

  - Create a directory for the container: `ds init myproject/ds @proj-example-org`

  - Fix the settings:
    ```
    cd /var/ds/proj-example-org/
    vim settings.sh
    ```

  - Build image, create the container and configure it: `ds make`


## Access the website

  - Tell `wsproxy` to manage the domain of this container: `ds wsproxy add`

  - Tell `wsproxy` to get a free letsencrypt.org SSL certificate for this domain (if it is a real one):
    ```
    ds wsproxy ssl-cert --test
    ds wsproxy ssl-cert
    ```

  - If the domain is not a real one, add to `/etc/hosts` the line
    `127.0.0.1 proj.example.org` and then try
    https://proj.example.org in browser.


## Other commands

    ds help

    ds shell
    ds stop
    ds start
    ds snapshot

    ds runcfg set-adminpass <new-drupal-admin-passwd>
    ds runcfg set-domain <new.domain>
    ds runcfg emailsmtp <gmail-user> <gmail-passwd>

    ds runcfg dev/clone proj proj_test
    ds runcfg dev/clone_rm proj_test
    ds runcfg dev/clone proj proj1

    ds backup [proj1]
    ds restore <backup-file.tgz> [proj1]

#A 'Hello World' in 5 minutes

This chapters goals include:

* Installing Dylan
* Creating a "Hello World" project
* Compiling and running the project

##Installing OpenDylan

###OS X

the 2013.2 release of Open Dylan can be installed by running the commands below.  An install script is also available in chapter_001/projects/install-dylan/darwin

```bash
curl -O http://opendylan.org/downloads/opendylan/2013.2/opendylan-2013.2-x86-darwin.tar.bz2
tar -xvzf opendylan-2013.2-x86-darwin.tar.bz2
sudo mv opendylan-2013.2 /opt/
echo "export PATH=/opt/opendylan-2013.2/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
```

##Creating your first project

Dylan can auto-build a project for you using the "make-dylan-app" command.  Run the following command in the directory you keep all your dylan projects (for me that is /home/philipwoods/workspace):

```bash
make-dylan-app hello-world
```

###A basic Dylan Project structures

make-dylan-app will generate the following directory structure:

```
└── hello-world
    ├── hello-world.dylan
    ├── hello-world.lid
    ├── library.dylan
    └── registry
        └── generic
            └── hello-world
```

Here is a quick breakdown of what each component in the project is:

* hello-world.dylan: the main source file.
* hello-world.lid
* library.dylan
* registry

###Looking at the source structure

The source for hello-world.dylan

```dylan
Module: hello-world
Synopsis: 
Author: 
Copyright: 

define function main (name :: <string>, arguments :: <vector>)
  format-out("Hello, world!\n");
  exit-application(0);
end function main;

main(application-name(), application-arguments());
```

##Compiling your project

##Notes

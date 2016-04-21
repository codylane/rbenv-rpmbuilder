# rbenv-rpmbuilder
A small automation project to build rbenv into a RPM along with RBENV compatible rubies.

# References
* https://github.com/rbenv/rbenv
* https://github.com/rbenv/ruby-build

# Pre-Condition Information
1. You need a docker host up and running.
2. You need the docker client libaries installed on your workstation.
3. You like the fact that running a single command in your terminal will give you options to install rubies through RPM and still use RBENV in production.  

# Why?
This was a small idea I had based off another CICD project that I'm working on in my spare time.  I thought other people might benefit from this small proof of concept.  This was created because I got tired of all the wait times for compiling rubies when I wanted to test a small change on ephimeral virtual machines.

# What does it do?
This repo contains all the bits necessary to compile Rubies from source that work with rbenv and are finally turned into an RPM as an end result.  When the build finishes and your container is running, you are presented with a yum repo that you can use to start installing rubies on other machines.  This project essentially automates all these steps for you so you can focus on the more important things like writting more code.

# How do I use this?
* clone the repository
```
cd rbenv-rpmbuilder
export DOCKER_HOST=1.2.3.4:2375
./build.sh
```

You would expect to see something like this if the container is built successfully
```
Successfully built 5c1a4f936138
http://1.2.3.4:32769
```

NOTE: `http://1.2.3.4:32769` is what you want to use in your browser so you can download the rbenv + rbenv-rubies or just browse.  Lastly, the other thing you'll get for free is a `rpm-rbenv.repo` in your current directory which allows you to use as a custom yum repo. 
# Can I Add A New Ruby To This?
Yup
* Just copy one of the existing `rbenv-ruby*.spec' files to a new name.
```
cp rbenv-ruby-2.1.8.spec rbenv-ruby-2.2.0.spec
```
Edit this new file you just created and update these lines.
```
%define rbenv_root      /opt/rbenv                                                                                      
%define ruby_major      2                                                                                               
%define ruby_minor      2                                                                                               
%define ruby_patch      0                                                                                               
%define ruby_build      0 
```

Edit your Dockerfile and add this
```
COPY rbenv-ruby-2.2.0.spec /
```

build it!
```
./build.sh
```

FROM centos:6u7

RUN yum -y install \
    rpmdevtools \
    git \
    openssl-devel \
    libyaml-devel \
    libffi-devel \
    readline-devel \
    zlib-devevel \
    gdbm-devel \
    ncurses-devel \
    createrepo

RUN getent passwd rpmbuild >>/dev/null 2>&1 || useradd -m -d /home/rpmbuild -s /bin/bash rpmbuild

COPY setup-rpmbuild.sh /
COPY rbenv.spec /
COPY start-web.sh /
COPY rbenv-ruby-2.1.8.spec /
COPY rbenv-ruby-1.9.3.spec /

RUN su - rpmbuild -c /setup-rpmbuild.sh

RUN yum install -y /home/rpmbuild/rpmbuild/RPMS/noarch/rbenv-*.rpm
RUN mkdir -p /opt/rbenv/versions && \
    chown rpmbuild /opt/rbenv/versions

# rbenv-ruby.spec
RUN su - rpmbuild -c 'cp /rbenv-ruby-*.spec $HOME/rpmbuild/SPECS/'
RUN su - rpmbuild -c 'QA_RPATHS=0x0002 rpmbuild -ba $HOME/rpmbuild/SPECS/rbenv-ruby-*.spec'
RUN su - rpmbuild -c 'createrepo $HOME/rpmbuild/RPMS'

EXPOSE 8080

CMD ["/bin/bash", "-c", "/start-web.sh"]

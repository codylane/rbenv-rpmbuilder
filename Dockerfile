FROM centos:8

RUN yum clean all && \
    yum install -y epel-release && \
    yum -y install   \
      autoconf       \
      automake       \
      rpmdevtools    \
      gcc            \
      git            \
      make           \
      python2        \
      openssl-devel  \
      yaml-cpp-devel \
      libffi-devel   \
      readline-devel \
      zlib-devel     \
      gdbm-devel     \
      ncurses-devel  \
      rsync          \
      createrepo     && \
    getent passwd rpmbuild >>/dev/null 2>&1 || useradd -m -d /home/rpmbuild -s /bin/bash rpmbuild

COPY setup-rpmbuild.sh /
COPY rbenv.spec /
COPY start-web.sh /
COPY rbenv-ruby-2.5.8.spec /

RUN su - rpmbuild -c /setup-rpmbuild.sh                                                     && \
    yum install -y /home/rpmbuild/rpmbuild/RPMS/noarch/rbenv-*.rpm                          && \
    mkdir -p /opt/rbenv/versions                                                            && \
    chown rpmbuild /opt/rbenv/versions                                                      && \
    su - rpmbuild -c 'cp /rbenv-ruby-*.spec $HOME/rpmbuild/SPECS/'                          && \
    su - rpmbuild -c 'QA_RPATHS=0x0002 rpmbuild -ba $HOME/rpmbuild/SPECS/rbenv-ruby-*.spec' && \
    su - rpmbuild -c 'createrepo $HOME/rpmbuild/RPMS'

EXPOSE 8080

CMD ["/bin/bash", "-c", "/start-web.sh"]

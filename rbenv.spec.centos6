%define rbenv_root      /opt/rbenv

Name:           rbenv
Version:        %%<RBENV_VERSION>%%
Release:        1%{?dist}
Summary:        Groom your apps Ruby environment

Group:          System/Applications
License:        MIT
URL:            https://github.com/rbenv/rbenv/archive/v%%<RBENV_VERSION>%%.tar.gz
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

BuildRequires:  git gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

%description
Use rbenv to pick a Ruby version for your application and guarantee that your development
environment matches production. Put rbenv to work with Bundler for painless
Ruby upgrades and bulletproof deployments.

%prep
%setup -q

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{rbenv_root}
cp -ra * %{buildroot}%{rbenv_root}
install -d -m0777 %{buildroot}%{rbenv_root}/shims

mkdir -p %{buildroot}%{_sysconfdir}/profile.d
cat > %{buildroot}%{_sysconfdir}/profile.d/rbenv.sh << EOF
# rbenv setup
export RBENV_ROOT=%{rbenv_root}
export PATH="%{rbenv_root}/bin:%{rbenv_root}/shims:\$PATH"
eval "\$(rbenv init -)"
EOF

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/opt
%doc README.md LICENSE
%attr(0777,root,root) %dir %{rbenv_root}/shims
%attr(0755,root,root) %{_sysconfdir}/profile.d/rbenv.sh

%changelog

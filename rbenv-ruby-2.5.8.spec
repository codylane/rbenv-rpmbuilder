%define rbenv_root      /opt/rbenv
%define ruby_major      2
%define ruby_minor      5
%define ruby_patch      8
%define ruby_build      0
%define ruby_release    %{ruby_major}.%{ruby_minor}.%{ruby_patch}

%if %{ruby_build}
%define install_version %{version}-%{ruby_build}
%else
%define install_version %{version}
%endif

Name:           rbenv-ruby
Version:        %{ruby_release}
Release:        1%{?dist}
Summary:        Contains ruby-%{install_version} which can be used with rbenv

Group:          Development/Languages
License:        MIT
URL:            http://ftp.ruby-lang.org/pub/ruby/ruby-%{install_version}.tar.gz
Source0:        %{name}-%{install_version}.tar.gz

Provides: %{name} = %{ruby_release}

BuildRequires:  git gcc bzip2 openssl-devel yaml-cpp-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
Requires:       rbenv

%description
Ruby is the interpreted scripting language for quick and easy
object-oriented programming.  It has many features to process text
files and to do system management tasks (as in Perl).  It is simple,
straight-forward, and extensible.

%prep
rbenv install %{install_version}
rsync -a %{rbenv_root}/versions/%{install_version} .
tar czf %{_sourcedir}/%{name}-%{install_version}.tar.gz -C %{install_version} .

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{rbenv_root}/versions/
rsync -a %{install_version} %{buildroot}%{rbenv_root}/versions/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{rbenv_root}/versions/%{install_version}/bin
%{rbenv_root}/versions/%{install_version}/include
%{rbenv_root}/versions/%{install_version}/lib
%doc %{rbenv_root}/versions/%{install_version}/share
%attr(0755,root,root) %dir %{rbenv_root}/versions

%changelog

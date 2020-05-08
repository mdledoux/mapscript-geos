Name:           mapscript
Version:        7.4.4
Release:        0
Summary:        libmapserver required for php-mapscript

Group:          TecAdmin
BuildArch:      noarch
License:        GPL
URL:            https://repo-01.unh.edu/it-rcc/php-module-builds/mapscript-geos
#Source0:	

%description
An package consisting of two PHP modules:  geos and mapscript

%define _rpmdir /rpmbuild/RPMS
#%define _srpmdir /rpmbuild/RPMS


#%prep
#rm -rf $RPM_BUILD_DIR/

#%setup -q

%build
%install
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/lib
cp -rP /usr/local/lib/libmapserver.so         $RPM_BUILD_ROOT/usr/local/lib/libmapserver.so
cp -rP /usr/local/lib/libmapserver.so.2       $RPM_BUILD_ROOT/usr/local/lib/libmapserver.so.2
cp -rP /usr/local/lib/libmapserver.so.7.4.4   $RPM_BUILD_ROOT/usr/local/lib/libmapserver.so.7.4.4


%files

/usr/local/lib/
#/usr/local/lib/libmapserver.so
#/usr/local/lib/libmapserver.so.2
#/usr/local/lib/libmapserver.so.7.4.4





%changelog
* Wed May 6 2020 Martin Ledoux  1.0.0
  - Initial rpm release

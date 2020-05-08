Name:           mapscript
Version:        7.4.4
Release:        7.2.24
Summary:        Add mapscript to rh-php72 SCL

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
install -m 0755 -d $RPM_BUILD_ROOT/etc/opt/rh/rh-php72/php.d
cp -r  /etc/opt/rh/rh-php72/php.d/mapscript.ini  $RPM_BUILD_ROOT/etc/opt/rh/rh-php72/php.d/
install -m 0755 -d $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules
cp -rP /opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so  $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so
cp -rP /opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so       $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so


%files
/etc/opt/rh/rh-php72/php.d/
#/etc/opt/rh/rh-php72/php.d/mapscript.ini
#/etc/opt/rh/rh-php72/php.d/geos.ini
/opt/rh/rh-php72/root/usr/lib64/php/modules/
#/opt/rh/rh-php72/root/usr/lib64/php/modules/geos.so
#/opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so
#/opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so





%changelog
* Wed May 6 2020 Martin Ledoux  1.0.0
  - Initial rpm release

Name:           mapscript-geos
Version:        1
Release:        0
Summary:        Add mapscript and geos to rh-php72 SCL

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
cp -r /etc/opt/rh/rh-php72/php.d/geos.ini       $RPM_BUILD_ROOT/etc/opt/rh/rh-php72/php.d/
install -m 0755 -d $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules
cp -rP /opt/rh/rh-php72/root/usr/lib64/php/modules/geos.so                $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules/geos.so
cp -rP /opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so  $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so
cp -rP /opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so       $RPM_BUILD_ROOT/opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/lib
cp -rP /usr/local/lib/libmapserver.so         $RPM_BUILD_ROOT/usr/local/lib/libmapserver.so
cp -rP /usr/local/lib/libmapserver.so.2       $RPM_BUILD_ROOT/usr/local/lib/libmapserver.so.2
cp -rP /usr/local/lib/libmapserver.so.7.4.4   $RPM_BUILD_ROOT/usr/local/lib/libmapserver.so.7.4.4


%files
/etc/opt/rh/rh-php72/php.d/
#/etc/opt/rh/rh-php72/php.d/mapscript.ini
#/etc/opt/rh/rh-php72/php.d/geos.ini
/opt/rh/rh-php72/root/usr/lib64/php/modules/
#/opt/rh/rh-php72/root/usr/lib64/php/modules/geos.so
#/opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so
#/opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so
/usr/local/lib/
#/usr/local/lib/libmapserver.so
#/usr/local/lib/libmapserver.so.2
#/usr/local/lib/libmapserver.so.7.4.4





%changelog
* Tue Oct 24 2017 Rahul Kumar  1.0.0
  - Initial rpm release

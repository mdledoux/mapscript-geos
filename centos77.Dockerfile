FROM centos:centos7.7.1908
LABEL maintainer="martin.ledoux@unh.edu"
ENV PKG_MAN=yum

RUN $PKG_MAN -y install wget git   epel-release centos-release-scl  yum-utils
RUN yum-config-manager --enable centos-sclo-rh



RUN $PKG_MAN -y install cmake make gcc-c++   swig3 file    fcgi fcgi-devel \
	libxml2 libxml2-devel  zlib zlib-devel  libjpeg-turbo-devel freetype-devel giflib-devel libpng-devel \
	fribidi fribidi-devel  harfbuzz harfbuzz-devel  cairo cairo-devel protobuf protobuf-c protobuf-devel protobuf-c-compiler \
	proj proj-epsg proj-devel  geos geos-devel   postgis postgis-devel postgresql-devel  gdal gdal-libs gdal-devel \
#	php-geos \
#	php-pecl-pq \
	rh-php72-php rh-php72-php-devel \
	;

#WORKDIR  /usr/lib64
#RUN ln -s /opt/rh/rh-php72/root/usr/lib64/php
WORKDIR  /usr/include
RUN ln -s /opt/rh/rh-php72/root/usr/include/php


WORKDIR /
RUN wget http://download.osgeo.org/mapserver/mapserver-7.4.4.tar.gz && \
	tar xfz mapserver-7.4.4.tar.gz && \
	mkdir -p mapserver-7.4.4/build 

WORKDIR /mapserver-7.4.4/build
RUN sed -i '/WITH_PHP / s/OFF/ON/g'        ../CMakeLists.txt      && \
	sed -i '/WITH_PHPNG / s/OFF/ON/g'      ../CMakeLists.txt  && \
	sed -i '/WITH_PROTOBUFC / s/ON/OFF/g'  ../CMakeLists.txt
#Set option WITH_PROTOBUFC to 'OFF'
#Set option WITH_PHP to 'ON'
#Set option WITH_PHPNG to 'ON'


#RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib    &&  \
#RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib64  &&  \
RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib64   -DPHP_EXTENSION_DIR=/opt/rh/rh-php72/root/usr/lib64/php/modules     &&  \
	make  &&  \
	make install && \
	true;
# -- Will install files to /usr/local
# -- Will install libraries to /usr/local/lib


WORKDIR /
RUN git clone https://git.osgeo.org/gitea/geos/php-geos.git
WORKDIR /php-geos
ENV PATH=/opt/rh/rh-php72/root/bin/:$PATH
RUN ./autogen.sh  && \
	./configure  && \
	make # generates modules/geos.so
RUN make install

WORKDIR /


#RUN mkdir -p  build_rpm{/opt/rh/rh-php72/root/usr/lib64/php/modules/,/usr/local/lib,/etc/opt/rh/rh-php72/php.d/}   && \
#	cp -p /opt/rh/rh-php72/root/usr/lib64/php/modules/geos.so   build_rpm/opt/rh/rh-php72/root/usr/lib64/php/modules/   && \
#	cp -p /opt/rh/rh-php72/root/usr/lib64/php/modules/php_mapscript.so   build_rpm/opt/rh/rh-php72/root/usr/lib64/php/modules/   && \
#	cp -p /opt/rh/rh-php72/root/usr/lib64/php/modules/libphp_mapscriptng.so   build_rpm/opt/rh/rh-php72/root/usr/lib64/php/modules/   && \
#	cp -P /usr/local/lib/*libmapserver* build_rpm/usr/local/lib   && \
#	echo "extension=php_mapscript.so" >  build_rpm/etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
#	echo  >>  build_rpm/etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
#	echo "extension=libphp_mapscriptng.so" >>  build_rpm/etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
#	echo "extension=geos.so" >  build_rpm/etc/opt/rh/rh-php72/php.d/geos.ini  && \
#	true;
	

RUN	echo "extension=php_mapscript.so" >  /etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
	echo  >>  /etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
	echo "extension=libphp_mapscriptng.so" >>  /etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
	echo "extension=geos.so" >  /etc/opt/rh/rh-php72/php.d/geos.ini  && \
	true;

# yum -y install rpm-build rpm-devel  rpmdevtools coreutils
RUN yum -y install rpm-build rpmdevtools #rpm-devel 
#RUN rpmdev-setuptree  &&  rpmbuild
RUN mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SRPMS,SOURCES,SPECS}
WORKDIR /rpmbuild
#VOLUME /rpmbuild
RUN ls /rpmbuild
ADD --chown=0:0  rpmbuild/ /rpmbuild
RUN ls -lah  /rpmbuild
RUN ls -lah  /rpmbuild/SPECS
#ADD rpmbuild.tar.gz /
#RUN tar xfz rpmbuild.tar.gz
RUN	echo "%_unpackaged_files_terminate_build      0"  >>  /etc/rpm/macros    && \
	echo "%_binaries_in_noarch_packages_terminate_build   0"   >>  /etc/rpm/macros
RUN rpmbuild  -ba SPECS/mapscript-geos.spec
RUN ls -lah /rpmbuild/RPMS
RUN rpm -qlp RPMS/noarch/mapscript-geos-1-0.noarch.rpm

WORKDIR /RPM
RUN cp /rpmbuild/RPMS/noarch/* .






WORKDIR /
CMD /bin/bash




## ls /opt/rh/rh-php72/root/usr/lib64/php/modules/
#geos.so  libphp_mapscriptng.so  php_mapscript.so

## ls /usr/local/lib
#libmapserver.so  libmapserver.so.2  libmapserver.so.7.4.4

## ls /etc/opt/rh/rh-php72/php.d/
# mapscript.ini
# geos.ini





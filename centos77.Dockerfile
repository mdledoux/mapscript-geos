#FROM centos:centos7.7.1908 as phpgeo_base
FROM centos:centos7.8.2003 as phpgeo_base
#FROM centos:centos8.1.1911 as phpgeo_base
LABEL maintainer="martin.ledoux@unh.edu"
ENV PKG_MAN=yum

## ls /opt/rh/rh-php72/root/usr/lib64/php/modules/
#geos.so  libphp_mapscriptng.so  php_mapscript.so

## ls /usr/local/lib
#libmapserver.so  libmapserver.so.2  libmapserver.so.7.4.4

## ls /etc/opt/rh/rh-php72/php.d/
# mapscript.ini
# geos.ini


RUN $PKG_MAN -y install wget git   epel-release centos-release-scl  yum-utils
RUN yum-config-manager --enable centos-sclo-rh

# yum -y install rpm-build rpm-devel  rpmdevtools coreutils
RUN $PKG_MAN -y install cmake make gcc-c++   swig3 file    fcgi fcgi-devel \
	libxml2 libxml2-devel  zlib zlib-devel  libjpeg-turbo-devel freetype-devel giflib-devel libpng-devel \
	fribidi fribidi-devel  harfbuzz harfbuzz-devel  cairo cairo-devel protobuf protobuf-c protobuf-devel protobuf-c-compiler \
	proj proj-epsg proj-devel  geos geos-devel   postgis postgis-devel postgresql-devel  gdal gdal-libs gdal-devel \
	rpm-build rpmdevtools \
#	php-geos \
#	php-pecl-pq \
#	php php-devel \
	rh-php72-php rh-php72-php-devel \
	;

RUN mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SRPMS,SOURCES,SPECS}
# This macro allows binary libraries (.so files) to be packaged into an RPM
RUN	echo "%_unpackaged_files_terminate_build      0"  >>  /etc/rpm/macros    && \
	echo "%_binaries_in_noarch_packages_terminate_build   0"   >>  /etc/rpm/macros






#================================================================================
# build the MapScript library, including php-mapscript and an RPM for each
#================================================================================
FROM phpgeo_base AS php_mapscript
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
RUN	echo "extension=php_mapscript.so" >  /etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
	echo  >>  /etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
	echo "; this is for SWIG-only, and requires a php file from ms4w.  php_mapscript supports old way and SWIG, no php include"  && \
	echo  >>  /etc/opt/rh/rh-php72/php.d/mapscript.ini  && \
	echo "; extension=libphp_mapscriptng.so" >>  /etc/opt/rh/rh-php72/php.d/mapscript.ini 

#RUN rpmdev-setuptree  &&  rpmbuild
WORKDIR /rpmbuild
ADD --chown=0:0  rpmbuild/mapscript /rpmbuild
ADD --chown=0:0  rpmbuild/libmapserver /rpmbuild

RUN rpmbuild  -ba SPECS/libmapserver.spec
RUN rpm -qlp RPMS/noarch/libmapserver-7.4.4-0.noarch.rpm

RUN rpmbuild  -ba SPECS/mapscript.spec
RUN rpm -qlp RPMS/noarch/php-mapscript-7.4.4-7.2.24.noarch.rpm
#RUN ls -lah /rpmbuild/RPMS/noarch


WORKDIR /RPM
RUN cp /rpmbuild/RPMS/noarch/* .

WORKDIR /
CMD /bin/bash






#================================================================================
# build php-geos and an RPM for each
#================================================================================
FROM phpgeo_base AS php_geos
WORKDIR /
RUN git clone https://git.osgeo.org/gitea/geos/php-geos.git
WORKDIR /php-geos
ENV PATH=/opt/rh/rh-php72/root/bin/:$PATH
RUN ./autogen.sh  && \
	./configure  && \
	make # generates modules/geos.so
RUN make install

WORKDIR /
RUN	echo "extension=geos.so" >  /etc/opt/rh/rh-php72/php.d/geos.ini 

#RUN rpmdev-setuptree  &&  rpmbuild
WORKDIR /rpmbuild
ADD --chown=0:0  rpmbuild/geos/ /rpmbuild

RUN rpmbuild  -ba SPECS/geos.spec
#RUN ls -lah /rpmbuild/RPMS/noarch
RUN rpm -qlp RPMS/noarch/php-geos-3.4.2-7.2.24.noarch.rpm

WORKDIR /RPM
RUN cp /rpmbuild/RPMS/noarch/* .

WORKDIR /
CMD /bin/bash




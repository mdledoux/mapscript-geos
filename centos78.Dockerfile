#FROM centos:centos7.7.1908 as phpgeo_base
FROM centos:centos7.8.2003 as phpgeo_base
#FROM centos:centos8.1.1911 as phpgeo_base
LABEL maintainer="martin.ledoux@unh.edu"
ENV PKG_MAN=yum

## ls /opt/rh/rh-php${PHP_SCL_VER_TAG}/root/usr/lib64/php/modules/
#geos.so  libphp_mapscriptng.so  php_mapscript.so

## ls /usr/local/lib
#libmapserver.so  libmapserver.so.2  libmapserver.so.${MAPSERVER_VER}

## ls /etc/opt/rh/rh-php${PHP_SCL_VER_TAG}/php.d/
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
	rh-php${PHP_SCL_VER_TAG}-php rh-php${PHP_SCL_VER_TAG}-php-devel \
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
#RUN ln -s /opt/rh/rh-php${PHP_SCL_VER_TAG}/root/usr/lib64/php
WORKDIR  /usr/include
RUN ln -s /opt/rh/rh-php${PHP_SCL_VER_TAG}/root/usr/include/php


WORKDIR /
RUN wget http://download.osgeo.org/mapserver/mapserver-${MAPSERVER_VER}.tar.gz && \
	tar xfz mapserver-${MAPSERVER_VER}.tar.gz && \
	mkdir -p mapserver-${MAPSERVER_VER}/build 

WORKDIR /mapserver-${MAPSERVER_VER}/build
RUN sed -i '/WITH_PHP / s/OFF/ON/g'        ../CMakeLists.txt      && \
	sed -i '/WITH_PHPNG / s/OFF/ON/g'      ../CMakeLists.txt  && \
	sed -i '/WITH_PROTOBUFC / s/ON/OFF/g'  ../CMakeLists.txt
#Set option WITH_PROTOBUFC to 'OFF'
#Set option WITH_PHP to 'ON'
#Set option WITH_PHPNG to 'ON'


#RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib    &&  \
#RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib64  &&  \
RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib64   -DPHP_EXTENSION_DIR=/opt/rh/rh-php${PHP_SCL_VER_TAG}/root/usr/lib64/php/modules     &&  \
	make  &&  \
	make install && \
	true;
# -- Will install files to /usr/local
# -- Will install libraries to /usr/local/lib

WORKDIR /
RUN echo "; this first option provides the old php-mapscript, and the new SWIG API, but doesn't require a file-include from ms4w"  >  /etc/opt/rh/rh-php${PHP_SCL_VER_TAG}/php.d/40-mapscript.ini 
RUN echo "extension=php_mapscript.so"  >>  /etc/opt/rh/rh-php${PHP_SCL_VER_TAG}/php.d/40-mapscript.ini 
RUN echo "; this is for SWIG-only, and requires a php file from ms4w.  php_mapscript supports old way and SWIG, no php include"  >>  /etc/opt/rh/rh-php${PHP_SCL_VER_TAG}/php.d/40-mapscript.ini
RUN echo "; extension=libphp_mapscriptng.so" >>  /etc/opt/rh/rh-php${PHP_SCL_VER_TAG}/php.d/40-mapscript.ini 

#RUN rpmdev-setuptree  &&  rpmbuild
WORKDIR /rpmbuild
ADD --chown=0:0  rpmbuild/mapscript /rpmbuild
ADD --chown=0:0  rpmbuild/libmapserver /rpmbuild

RUN rpmbuild  -ba SPECS/libmapserver.spec
RUN rpm -qlp RPMS/noarch/libmapserver-${MAPSERVER_VER}-0.noarch.rpm

RUN rpmbuild  -ba SPECS/mapscript.spec
RUN rpm -qlp RPMS/noarch/php-mapscript-${MAPSERVER_VER}-${PHP_VER}.noarch.rpm
#RUN ls -lah /rpmbuild/RPMS/noarch

ARG UID=1000
#USER $UID
WORKDIR /RPMs
CMD cp /rpmbuild/RPMS/noarch/* .




#================================================================================
# build php-geos and an RPM for each
#================================================================================
FROM phpgeo_base AS php_geos
WORKDIR /
RUN git clone https://git.osgeo.org/gitea/geos/php-geos.git
WORKDIR /php-geos
ENV PATH=/opt/rh/rh-php${PHP_SCL_VER_TAG}/root/bin/:$PATH
RUN ./autogen.sh  && \
	./configure  && \
	make # generates modules/geos.so
RUN make install

WORKDIR /
RUN	echo "extension=geos.so" >  /etc/opt/rh/rh-php${PHP_SCL_VER_TAG}/php.d/40-geos.ini 

#RUN rpmdev-setuptree  &&  rpmbuild
WORKDIR /rpmbuild
ADD --chown=0:0  rpmbuild/geos/ /rpmbuild

RUN rpmbuild  -ba SPECS/geos.spec
#RUN ls -lah /rpmbuild/RPMS/noarch
RUN rpm -qlp RPMS/noarch/php-geos-${GEOS_VER}-${PHP_VER}.noarch.rpm

ARG UID=1000
#USER $UID
WORKDIR /RPMs
CMD cp /rpmbuild/RPMS/noarch/* .



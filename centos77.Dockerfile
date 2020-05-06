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



CMD /bin/bash



## ls /opt/rh/rh-php72/root/usr/lib64/php/modules/
#geos.so  libphp_mapscriptng.so  php_mapscript.so

## ls /usr/local/lib
#libmapserver.so  libmapserver.so.2  libmapserver.so.7.4.4


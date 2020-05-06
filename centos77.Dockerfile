FROM centos:centos7.7.1908
LABEL maintainer="martin.ledoux@unh.edu"
ENV PKG_MAN=yum

RUN $PKG_MAN -y install wget git #  epel-release centos-release-scl  yum-utils
#This was a bad idea....seems to break things
#RUN yum-config-manager --enable centos-sclo-rh



RUN $PKG_MAN -y install cmake make gcc-c++   swig3 file    fcgi fcgi-devel php-pecl-pq \
	libxml2 libxml2-devel  zlib zlib-devel  libjpeg-turbo-devel freetype-devel giflib-devel libpng-devel \
	fribidi fribidi-devel  harfbuzz harfbuzz-devel  cairo cairo-devel protobuf protobuf-c protobuf-devel protobuf-c-compiler \
	proj proj-epsg proj-devel  geos geos-devel   postgis postgis-devel postgresql-devel  gdal gdal-libs gdal-devel \
	#php-geos \
	rh-php72-php rh-php72-php-devel \
	;


RUN wget http://download.osgeo.org/mapserver/mapserver-7.4.4.tar.gz && \
	tar xfz mapserver-7.4.4.tar.gz && \
	mkdir -p mapserver-7.4.4/build 

RUN sed -i '/WITH_PHP / s/OFF/ON/g'        ./CMakeLists.txt      && \
	sed -i '/WITH_PHPNG / s/OFF/ON/g'      ./CMakeLists.txt  && \
	sed -i '/WITH_PROTOBUFC / s/ON/OFF/g'  ./CMakeLists.txt
#Set option WITH_PROTOBUFC to 'OFF'
#Set option WITH_PHP to 'ON'
#Set option WITH_PHPNG to 'ON'

WORKDIR /mapserver-7.4.4/build
#cmake ..   -DCMAKE_INSTALL_LIBDIR=lib
RUN cmake ..   -DCMAKE_INSTALL_LIBDIR=lib64  &&  \
	make  &&  \
	make install
# -- Will install files to /usr/local
# -- Will install libraries to /usr/local/lib


RUN git clone https://git.osgeo.org/gitea/geos/php-geos.git
WORKDIR php-geos
RUN ./autogen.sh  && \
	./configure  && \
	make # generates modules/geos.so
RUN make install





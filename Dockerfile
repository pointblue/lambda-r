FROM public.ecr.aws/lambda/nodejs:12

# RUN yum check-update

RUN yum update -y
RUN yum upgrade -y
RUN yum install -y openssl openssl-devel libcurl-devel amazon-linux-extras wget tar gzip gcc gcc-c++

ENV PROJ_VERSION 4.9.3
RUN wget http://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz
RUN tar -zvxf proj-${PROJ_VERSION}.tar.gz
RUN cd proj-${PROJ_VERSION}/ \
&& ./configure --prefix=/tmp \
&& make \
&& make install

RUN cd ..

# Download, unzip, build static gdal/ogr2ogr
ENV GDAL_VERSION 2.2.3
RUN wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
RUN tar -zxvf gdal-${GDAL_VERSION}.tar.gz
RUN cd gdal-${GDAL_VERSION}/ \
&& ./configure \
    --with-geos \
    --with-geotiff=internal \
    --with-hide-internal-symbols \
    --with-libtiff=internal \
    --with-libz=internal \
    --with-threads \
    --without-bsb \
    --without-cfitsio \
    --without-cryptopp \
    --without-curl \
    --without-dwgdirect \
    --without-ecw \
    --without-expat \
    --without-fme \
    --without-freexl \
    --without-gif \
    --without-gif \
    --without-gnm \
    --without-grass \
    --without-grib \
    --without-hdf4 \
    --without-hdf5 \
    --without-idb \
    --without-ingres \
    --without-jasper \
    --without-jp2mrsid \
    --without-jpeg \
    --without-kakadu \
    --without-libgrass \
    --without-libkml \
    --without-libtool \
    --without-mrf \
    --without-mrsid \
    --without-mysql \
    --without-netcdf \
    --without-odbc \
    --without-ogdi \
    --without-openjpeg \
    --without-pcidsk \
    --without-pcraster \
    --without-pcre \
    --without-perl \
    --without-pg \
    --without-php \
    --without-png \
    --without-python \
    --without-qhull \
    --without-sde \
    --without-sqlite3 \
    --without-webp \
    --without-xerces \
    --without-xml2 \
    --disable-shared \
    --enable-static \
    --with-static-proj4=/tmp \
    --with-threads \
    --prefix /tmp \
&& make \
&& make install

# copy the built binaries and shared files where the system can find them
RUN cp /tmp/bin/* /usr/local/bin/ \
    && cp -R /tmp/lib/* /usr/lib64/

# install R script version 4.x
RUN amazon-linux-extras enable R4 \
    && yum clean metadata \
    && yum install -y R

#install git
RUN yum install -y git

# rgeos, rgdal, and raster dependencies
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  \
    && yum install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
    && yum install -y geos-devel

# R dependecies
RUN Rscript -e "install.packages(c('logger','logging','httr','jsonlite', 'yaml', 'rgeos', 'rgdal', 'raster'), repos = 'https://cloud.r-project.org/')"

# setup requirements to clone from github
RUN mkdir /root/.ssh && touch /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts && ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Main app code to handle lambda events
COPY app.js ${LAMBDA_TASK_ROOT}

# main R script file
COPY main.R ${LAMBDA_TASK_ROOT}

CMD ["app.handler"]

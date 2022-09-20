FROM osgeo/gdal:ubuntu-small-latest

# Add libraries
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update && apt-get install -y \
      build-essential \
      g++-11 \
      git \
      libsqlite3-dev \
      sqlite \
      zlib1g-dev \
      && rm -rf /var/lib/apt/lists/*

ENV CXX=g++-11

# Add Tippecanoe (protomaps version)
RUN git clone https://github.com/felt/tippecanoe.git /tippecanoe && \
    cd tippecanoe && \
    make -j && \
    make install && \
    cd ../ && \
    rm -rf ./tippecanoe

RUN apt-get remove -y \
   build-essential \
   g++-11 \
   git \
   libsqlite3-dev \
   zlib1g-dev \
   && apt-get autoremove -y

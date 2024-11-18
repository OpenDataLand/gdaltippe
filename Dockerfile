FROM ghcr.io/protomaps/go-pmtiles AS pmtiles

# Build the gdal image
FROM ghcr.io/osgeo/gdal:ubuntu-small-latest

# Add libraries
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update && apt-get install -y \
    build-essential \
    g++-11 \
    git \
    jq \
    libsqlite3-dev \
    sqlite3 \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ENV CXX=g++-11

# Add Tippecanoe (felt version)
# Fetch the latest release of tippecanoe
RUN mkdir /tippecanoe && \
    cd /tippecanoe && \
    curl -s https://api.github.com/repos/felt/tippecanoe/releases/latest \
    | jq -r '.tarball_url' \
    | xargs curl -L -o tippecanoe.tar.gz && \
    tar -xzf tippecanoe.tar.gz --strip-components=1 && \
    make -j && \
    make install && \
    cd ../ && \
    rm -rf ./tippecanoe

# Copy the go-pmtiles executable from the pmtiles docker
COPY --from=pmtiles /go-pmtiles /usr/bin/pmtiles

# Remove unnecessary packages
RUN apt-get remove -y \
   build-essential \
   g++-11 \
   git \
   jq \
   && apt-get autoremove -y
FROM golang:1.20.8-alpine3.18 AS builder

# Build PMTiles
RUN apk add --no-cache git && \
   git clone https://github.com/protomaps/go-pmtiles.git /pmtiles && \
   cd /pmtiles && \
   CGO_ENABLED=0 go build -o /pmtiles/go-pmtiles

# Build the final image
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
      sqlite \
      zlib1g-dev \
      && rm -rf /var/lib/apt/lists/*

ENV CXX=g++-11

# Add Tippecanoe (felt version)
RUN git clone https://github.com/felt/tippecanoe.git /tippecanoe && \
    cd tippecanoe && \
    make -j && \
    make install && \
    cd ../ && \
    rm -rf ./tippecanoe

# Copy the go-pmtiles executable from the builder stage
COPY --from=builder /pmtiles/go-pmtiles /usr/bin/pmtiles

# Remove unnecessary packages
RUN apt-get remove -y \
   build-essential \
   g++-11 \
   git \
   libsqlite3-dev \
   zlib1g-dev \
   && apt-get autoremove -y

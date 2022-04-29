## Gdal Tippecanoe

This combines the [ogr2ogr tools](https://github.com/OSGeo/gdal/tree/master/docker) with [Tippecanoe](https://github.com/protomaps/tippecanoe) all in one Docker package, for great Geospatial ETLing.

You can use this to extract / convert your geospatial files with ogr2ogr and create an mbtiles file all on once Docker

## Example

1. Edit the example env file with your own values: `examples/postgis.env`

```
PGHOST=postgres
PGUSER=postgres
PGPASSWORD=postgres
PGDATABASE=postgres
```

2. Edit the example bash file with your table information: `examples/download_table.sh`
```
#!/bin/bash

ogr2ogr -f FlatGeoBuf example.fgb PG:"" -sql "SELECT name, the_geom FROM test_table" &&\
tippecanoe -zg -o test_table.mbtiles --drop-densest-as-needed example.fgb && \
rm ./example.fgb

echo "Done!"
```

3. Run ogr2ogr and tippecanoe in Docker:
```
docker build -t gdaltippe .
docker run -v `pwd`:`pwd` -w `pwd` -i -t  gdaltippe --env-file ./examples/postgis.env bash ./examples/download_table.sh
```

4. You should now have a file `test_table.mbtiles` in your present working directory.

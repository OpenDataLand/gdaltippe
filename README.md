
# gdal-tippecanoe

This Docker package combines the `ogr2ogr` tools from [GDAL](https://github.com/OSGeo/gdal/tree/master/docker) with the [Felt](https://felt.com/) version of [Tippecanoe](https://github.com/felt/tippecanoe) and the [go-pmtiles](https://github.com/protomaps/go-pmtiles) tool for geospatial ETLing.

Use this package to extract/convert your geospatial files with `ogr2ogr` and create an MBTiles file in a single Docker command.

## Example

1.  Edit the example environment file (`postgis.env`) with your own values:

```makefile
PGHOST=postgres
PGUSER=postgres
PGPASSWORD=postgres
PGDATABASE=postgres
```

2.  Edit the example Bash file (`download_table.sh`) with your table information:

```bash
ogr2ogr \
  -f FlatGeoBuf example.fgb \
  PG:"" -sql "SELECT name, the_geom FROM test_table" && \
tippecanoe \
  -zg \
  -o test_table.mbtiles \
  --drop-densest-as-needed \
  example.fgb && \
rm ./example.fgb

echo "Done!"
``` 

3.  Run `ogr2ogr` and `tippecanoe` in Docker:

```bash
docker run \
  -v `pwd`:`pwd` \
  -w `pwd` -i -t \
  jimmyrocks/gdaltippe:latest \
  --env-file ./postgis.env \
  bash ./download_table.sh
``` 

4.  You should now have a file named `test_table.mbtiles` in your present working directory.

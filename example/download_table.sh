#!/bin/bash

ogr2ogr -f FlatGeoBuf example.fgb PG:"" -sql "SELECT name, the_geom FROM public.test_table" &&\
tippecanoe -zg -o test_table.mbtiles --drop-densest-as-needed example.fgb && \
rm ./example.fgb

echo "Done!"

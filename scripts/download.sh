#! /bin/bash

d=2014-08-09

while [ "$d" != 2017-07-04 ]
   do  make download DATE="$d" PG_DATABASE=mta_bus_archive ARCHIVE=mytransit 
    d=$(date -I -d "$d + 1 day")
    done

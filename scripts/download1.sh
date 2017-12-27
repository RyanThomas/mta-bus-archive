#! /bin/bash

d=2014-08-09

while [ "$d" != 2014-12-31 ]
   do  make download DATE="$d" PG_DATABASE=mta_bus_archive ARCHIVE=mytransit 
    d=$(date -I -d "$d + 1 day")
    done
    
d=2015-01-01

while [ "$d" != 2015-12-31 ]
   do  make download DATE="$d" PG_DATABASE=mta_bus_archive ARCHIVE=mytransit 
    d=$(date -I -d "$d + 1 day")
    done
    
    
    
OR trip_id LIKE '%SBS15%'
OR trip_id LIKE '%SBS23%'
OR trip_id LIKE '%SBS34%'
OR trip_id LIKE '%SBS60%'
OR trip_id LIKE '%SB79%'
OR trip_id LIKE '%SBS86%'
OR trip_id LIKE '%SB44%'
OR trip_id LIKE '%SBS46%'
OR trip_id LIKE '%SBS12%'
OR trip_id LIKE '%SBS41%'
OR trip_id LIKE '%SBS79%'
OR trip_id LIKE '%SBS70%'
OR trip_id LIKE '%SBS44%'
OR trip_id LIKE '%M15%'
OR trip_id LIKE '%M23%'
OR trip_id LIKE '%M34%'
OR trip_id LIKE '%M60%'
OR trip_id LIKE '%M79%'
OR trip_id LIKE '%M86%'
OR trip_id LIKE '%B44%'
OR trip_id LIKE '%B46%'
OR trip_id LIKE '%BX12%'
OR trip_id LIKE '%BX41%'
OR trip_id LIKE '%BX6%'
OR trip_id LIKE '%S79%'
OR trip_id LIKE '%Q44%'
OR trip_id LIKE '%Q70%'
OR trip_id LIKE '%Q52%'
OR trip_id LIKE '%Q53%'
OR trip_id LIKE '%M14%'
OR trip_id LIKE '%M66%'
OR trip_id LIKE '%M96%'
OR trip_id LIKE '%B41%'
OR trip_id LIKE '%Bx15%'
OR trip_id LIKE '%Q20%'
OR trip_id LIKE '%Q50%'
OR trip_id LIKE '%S59%'
OR trip_id LIKE '%S78%'


-- create endpoints
INSERT INTO endpoints (
SELECT rt_vehicle_positions.latitude,
  rt_vehicle_positions.longitude,
  rt_vehicle_positions.timestamp,
  rt_vehicle_positions.trip_id AS id
--INTO endpoints
 FROM rt_vehicle_positions
WHERE rt_vehicle_positions.trip_id NOT LIKE '%Sunday%'
 AND rt_vehicle_positions.trip_id NOT LIKE '%Saturday%'
  AND  (rt_vehicle_positions.trip_id LIKE '%SBS15%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS23%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS34%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS60%'
  OR rt_vehicle_positions.trip_id LIKE '%SB79%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS86%'
  OR rt_vehicle_positions.trip_id LIKE '%SB44%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS46%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS12%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS41%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS79%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS70%'
  OR rt_vehicle_positions.trip_id LIKE '%SBS44%'
  OR rt_vehicle_positions.trip_id LIKE '%M15%'
  OR rt_vehicle_positions.trip_id LIKE '%M23%'
  OR rt_vehicle_positions.trip_id LIKE '%M34%'
  OR rt_vehicle_positions.trip_id LIKE '%M60%'
  OR rt_vehicle_positions.trip_id LIKE '%M79%'
  OR rt_vehicle_positions.trip_id LIKE '%M86%'
  OR rt_vehicle_positions.trip_id LIKE '%B44%'
  OR rt_vehicle_positions.trip_id LIKE '%B46%'
  OR rt_vehicle_positions.trip_id LIKE '%BX12%'
  OR rt_vehicle_positions.trip_id LIKE '%BX41%'
  OR rt_vehicle_positions.trip_id LIKE '%BX6%'
  OR rt_vehicle_positions.trip_id LIKE '%S79%'
  OR rt_vehicle_positions.trip_id LIKE '%Q44%'
  OR rt_vehicle_positions.trip_id LIKE '%Q70%'
  OR rt_vehicle_positions.trip_id LIKE '%Q52%'
  OR rt_vehicle_positions.trip_id LIKE '%Q53%'
  OR rt_vehicle_positions.trip_id LIKE '%M14%'
  OR rt_vehicle_positions.trip_id LIKE '%M66%'
  OR rt_vehicle_positions.trip_id LIKE '%M96%'
  OR rt_vehicle_positions.trip_id LIKE '%B41%'
  OR rt_vehicle_positions.trip_id LIKE '%Bx15%'
  OR rt_vehicle_positions.trip_id LIKE '%Q20%'
  OR rt_vehicle_positions.trip_id LIKE '%Q50%'
  OR rt_vehicle_positions.trip_id LIKE '%S59%'
  OR rt_vehicle_positions.trip_id LIKE '%S78%'
      )
) ;


--DROP TABLE endpoints

INSERT INTO trips (
SELECT trip_id AS id, split_part(trip_id, '_', 3) AS route,
  MAX(rt_vehicle_positions.timestamp) AS st_time,
  MIN(rt_vehicle_positions.timestamp) AS nd_time,
  (MAX(rt_vehicle_positions.dist_along_route) -
   MIN(rt_vehicle_positions.dist_along_route) ) / 1000 AS distance,
  ( (NULLIF ( EXTRACT(EPOCH FROM MAX(rt_vehicle_positions.timestamp) -
   MIN(rt_vehicle_positions.timestamp) ), 0)) / 60) AS minutes,
  ( ( MAX(rt_vehicle_positions.dist_along_route) -
    MIN(rt_vehicle_positions.dist_along_route)) / 1000 ) /
   ( NULLIF ( EXTRACT(EPOCH FROM MAX(rt_vehicle_positions.timestamp) -
    MIN(rt_vehicle_positions.timestamp) ) , 0) / 3600 )  AS km_per_hour
FROM rt_vehicle_positions
--WHERE latitude BETWEEN (latitude - stddev(latitude))
--      AND (latitude + stddev(latitude))
WHERE rt_vehicle_positions.trip_id NOT LIKE '%Sunday%'
 AND rt_vehicle_positions.trip_id NOT LIKE '%Saturday%'
  AND  ( trip_id LIKE '%SBS15%'
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
  OR trip_id LIKE '%S78%' )
GROUP BY rt_vehicle_positions.trip_id ) ;

-- combine
INSERT INTO starts (
  SELECT trips.id AS id,
  trips.st_time AS start_time,
  endpoints.latitude AS st_latitude,
  endpoints.longitude AS st_longitude
--INTO starts
  FROM trips JOIN endpoints
  ON (trips.id = endpoints.id
        AND trips.st_time = endpoints.timestamp) );

INSERT INTO ends (
  SELECT
    trips.id            AS id,
    trips.st_time       AS end_time,
    endpoints.latitude  AS nd_latitude,
    endpoints.longitude AS nd_longitude,
    trips.minutes       AS minutes,
    trips.km_per_hour   AS km_per_hour,
    trips.distance      AS distance
--  INTO ends
  FROM trips, endpoints
  WHERE trips.id = endpoints.id
        AND trips.nd_time = endpoints.timestamp) ;

INSERT INTO final (
SELECT starts.id AS id,
  starts.start_time AS start_time,
  starts.st_latitude AS st_latitude,
  starts.st_longitude AS st_longitude,
  ends.end_time AS end_time,
  ends.nd_latitude AS nd_latitude,
  ends.nd_longitude AS nd_longitude,
  ends.minutes AS minutes,
  ends.km_per_hour AS km_per_hour,
  ends.distance AS distance
--INTO final
FROM starts
  JOIN ends ON starts.id = ends.id );

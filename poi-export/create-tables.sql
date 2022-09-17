-- helper functions
CREATE OR REPLACE FUNCTION determine_class(mapping_key TEXT, subclass TEXT)
RETURNS TEXT AS $$
BEGIN
  RETURN CASE
    WHEN mapping_key = 'highway' AND subclass IN ('bus_stop') THEN 'public_transit'
    WHEN mapping_key = 'amenity' AND subclass IN ('bus_station', 'ferry_terminal') THEN 'public_transit'
    WHEN mapping_key = 'railway' AND subclass IN ('station', 'tram_stop', 'halt', 'subway_entrance') THEN 'public_transit'
    ELSE mapping_key
  END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION determine_subclass(mapping_key TEXT, subclass TEXT)
RETURNS TEXT AS $$
BEGIN
  RETURN subclass;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- merge points and polygons and filter data
CREATE VIEW pois_filtered AS
WITH merged_data AS (
	SELECT
		id,
		osm_id,
		'point' AS type,
		name,
		name_en,
		name_de,
		tags,
		subclass,
		mapping_key,
		geometry
	FROM
		osm_poi_point
	UNION ALL
	SELECT
		id,
		osm_id,
		'polygon' AS type,
		name,
		name_en,
		name_de,
		tags,
		subclass,
		mapping_key,
		ST_Centroid(geometry) AS geometry
	FROM
		osm_poi_polygon
)
SELECT
	*
FROM
	merged_data
WHERE
	name IS NOT NULL AND name <> '' -- ignore POIs with no name
	AND NOT(mapping_key = 'landuse' AND subclass IN ('brownfield', 'greenfield')) -- ignore construction sites
	AND NOT(mapping_key = 'barrier' AND subclass <> 'border_control') -- ignore all gates except for border crossings
	AND NOT(mapping_key = 'tourism' AND subclass = 'information' AND name IN ('BKK-FUTÁR', 'vsb bkk futár')); -- specific to Budapest, Hungary

-- create view for the final export
CREATE VIEW pois_export AS
SELECT
	osm_id,
	name,
	determine_class(mapping_key, subclass) AS class,
	determine_subclass(mapping_key, subclass) AS subclass,
	ROUND(ST_Y(geometry)::decimal, 6) AS lat,
	ROUND(ST_X(geometry)::decimal, 6) AS lon
FROM
	pois_filtered;

# osm-poi-export

Tool for extracting POIs from OpenStreetMap in CSV format.

This project was inspired by [OSM Names](https://osmnames.org/), which can be used to extract house numbers, street names, towns, cities, and other administrative units from OpenStreetMap for full text search. However, POIs are not yet supported by the current version of OSM Names.

## Getting Started

Make sure you have Docker and Docker Compose installed, and free space greater than 4 times the size of the extract you are going to work with (e.g. at least 275 GB for the whole planet).

1) Download an OSM extract from your provider of choice (e.g. http://download.geofabrik.de/index.html) and place it inside the `data` directory.

2) Change the value of the `OSM_PBF_FILENAME` variable in  `.env` to match the name of the downloaded extract.

3) Run the following command:
```
docker-compose run poi-export
```

4) Find the output file inside the `data` directory.

## Acknowledgements

This project makes use of the following open-source projects:

* imposm3 – https://github.com/omniscale/imposm3
* OpenMapTiles – https://github.com/openmaptiles/openmaptiles

Specifically, the imposm3 mappings used by this project were based on similar mappings used by OpenMapTiles to build its POI layer. This is to ensure that the logic for determining whether an object is considered a POI or not matches the behavior of OpenMapTiles as closely as possible.

## Data Attribution

As with all extracts from OpenStreetMap, the exported data might be considered a derivative database and fall under the ODbL license. See OpenStreetMap's [Copyright Notice](https://www.openstreetmap.org/copyright) and [Legal FAQ](https://wiki.openstreetmap.org/wiki/Legal_FAQ) for more information.

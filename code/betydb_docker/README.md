## BETYdb Dockerfile README

This is included to allow users to re-run the code used to generate the phenotype data and experimental metadata contained in this data publication.

This directory contains information required to run the TERRA REF instance of BETYdb, a PostgreSQL that contains plot level derived phenotypes as well as experimental metadata. 

Because the database is run in Docker, it can be run on almost any desktop, laptop, or cloud computing environment. See https://www.docker.com/get-started for installation instructions. Then you can run the following commands in the same directory as the files named "Dockerfile" and "docker-compose.yml". 

```
docker-compose up -d postgres
docker-compose run --rm bety initialize
docker-compose run --rm bety sync
```
CREATE DATABASE record_store;
\c record_store;
CREATE TABLE albums (id serial PRIMARY KEY, name varchar, release_year int, price int);
CREATE TABLE songs (id serial PRIMARY KEY, name varchar, album_id int);
CREATE TABLE artists (id serial PRIMARY KEY, name varchar);
CREATE TABLE albums_artists (id serial PRIMARY KEY, artist_id int, album_id int);
DROP DATABASE record_store_test;
CREATE DATABASE record_store_test WITH TEMPLATE record_store;

-- To back up your database, go to the root directory of your project in the terminal. Run the following command in the bash shell (not in psql):
pg_dump [YOUR DATABASE NAME] > database_backup.sql

-- Now that we have a backup, we can quickly create a fresh database that includes our backup schema. 
createdb [DATABASE NAME]
psql [DATABASE_NAME] < database_backup.sql
createdb -T [DATABASE NAME] [TEST DATABASE NAME]

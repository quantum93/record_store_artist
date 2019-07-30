CREATE DATABASE record_store;
\c record_store;
CREATE TABLE albums (id serial PRIMARY KEY, name varchar, release_year int, price int);
CREATE TABLE songs (id serial PRIMARY KEY, name varchar, album_id int);
CREATE TABLE artists (id serial PRIMARY KEY, name varchar);
CREATE TABLE albums_artists (id serial PRIMARY KEY, artist_id int, album_id int);
DROP DATABASE record_store_test;
CREATE DATABASE record_store_test WITH TEMPLATE record_store;

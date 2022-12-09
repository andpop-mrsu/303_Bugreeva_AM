#!/bin/bash
python3 make_init_db.py
sqlite3 movies_rating.db < db_init.sql

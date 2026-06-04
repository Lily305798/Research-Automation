#!/bin/bash
sudo docker compose down -v
sudo docker compose build --no-cache scanner
sudo docker compose up -d
sudo docker compose logs python-app -f
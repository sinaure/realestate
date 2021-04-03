#!/bin/bash
mkdir -p data

aws s3 cp --endpoint-url=https://gateway.tardigradeshare.io s3://realestate/dvf_initial.sql ./data/1-dvf_initial.sql
aws s3 cp --endpoint-url=https://gateway.tardigradeshare.io s3://realestate/R093_Paca.sql ./data/2-R093_Paca.sql
aws s3 cp --endpoint-url=https://gateway.tardigradeshare.io s3://realestate/Insee-codes-France.sql ./data/3-import-codes.sql

docker-compose up

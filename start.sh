#!/bin/bash
mkdir -p data

export  AWS_ACCESS_KEY_ID=jx6fxmb3ofroe32ckk2cod7g2mfq
export AWS_SECRET_ACCESS_KEY=j2utyfd2bgnql45m6dqfpyialmm5g327j77oypoju2f672e2niybe

aws s3 cp --endpoint-url=https://gateway.tardigradeshare.io s3://realestate/dvf_initial.sql ./data/1-dvf_initial.sql
aws s3 cp --endpoint-url=https://gateway.tardigradeshare.io s3://realestate/R093_Paca.sql ./data/2-R093_Paca.sql
aws s3 cp --endpoint-url=https://gateway.tardigradeshare.io s3://realestate/Insee-codes-France.sql ./data/3-import-codes.sql

docker-compose up -d

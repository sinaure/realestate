FROM ubuntu:latest
RUN apt-get update -y && apt-get install -y python3 python3-dev python3-pip curl libcurl4-gnutls-dev libgnutls28-dev git libpq-dev 

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src
ADD docker/s3client/start.sh ./start.sh
RUN chmod a+x ./start.sh
RUN pip3 install awscli
CMD ["/usr/local/src/start.sh"]
ENTRYPOINT ["bash"]

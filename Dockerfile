FROM debian:stable-slim as verify
RUN apt-get update
RUN apt-get install -y curl gpg
RUN mkdir /litecoin
COPY litecoin.pub.key /litecoin/litecoin.pub.key
RUN curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-x86_64-linux-gnu.tar.gz --output /litecoin/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
RUN curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-linux-signatures.asc --output /litecoin/tmp.asc
RUN chmod 755 /litecoin/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
#convert line endings in signature file
RUN tr -d '\015' </litecoin/tmp.asc >/litecoin/litecoin-0.17.1-linux-signatures.asc
RUN chmod 755 /litecoin/litecoin-0.17.1-linux-signatures.asc
RUN gpg --import /litecoin/litecoin.pub.key
RUN gpg --verify /litecoin/litecoin-0.17.1-linux-signatures.asc
RUN cd /litecoin/ && sha256sum -c /litecoin/litecoin-0.17.1-linux-signatures.asc 2>&1 | grep OK

FROM debian:stable-slim as unpack
RUN mkdir /litecoin
COPY --from=verify /litecoin/litecoin-0.17.1-x86_64-linux-gnu.tar.gz /tmp/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
RUN tar -xzvf /tmp/litecoin-0.17.1-x86_64-linux-gnu.tar.gz -C /litecoin


FROM debian:stable-slim as final
RUN mkdir /litecoin
COPY --from=unpack /litecoin/litecoin-0.17.1/ /litecoin/

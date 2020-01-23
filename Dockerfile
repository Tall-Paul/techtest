FROM ubuntu 
RUN apt-get update
RUN mkdir ~/Downloads/litecoin && cd $_
RUN curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
RUN curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-linux-signatures.asc
COPY litecoin.pub.key ~/Downloads/litecoin
RUN gpg --import litecoin.pub.key
RUN gpg --verify litecoin-0.17.1-linux-signatures.asc
RUN litecoin-0.17.1-x86_64-linux-gnu.tar.gz litecoin-0.17.1-linux-signatures.asc | sha256sum --check


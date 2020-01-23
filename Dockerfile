FROM ubuntu 
RUN apt-get update
mkdir ~/Downloads/litecoin && cd $_
curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-linux-signatures.asc
COPY litecoin.pub.key ~/Downloads/litecoin
gpg --import litecoin.pub.key
gpg --verify litecoin-0.17.1-linux-signatures.asc
grep litecoin-0.17.1-x86_64-linux-gnu.tar.gz litecoin-0.17.1-linux-signatures.asc | sha256sum --check


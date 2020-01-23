FROM debian:stable-slim as verify
RUN apt-get update
RUN apt-get install -y curl gpg
RUN mkdir ~/litecoin
COPY litecoin.pub.key ~/litecoin/litecoin.pub.key
RUN curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-x86_64-linux-gnu.tar.gz --output ~/litecoin/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
RUN curl https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-linux-signatures.asc --output ~/litecoin/tmp.asc
#convert line endings in signature file
RUN tr -d '\015' <~/litecoin/tmp.asc >~/litecoin/litecoin-0.17.1-linux-signatures.asc
RUN cat ~/litecoin/litecoin.pub.key
RUN gpg --import ~/litecoin/litecoin.pub.key
RUN gpg --verify ~/litecoin/litecoin-0.17.1-linux-signatures.asc
RUN ~/litecoin/litecoin-0.17.1-x86_64-linux-gnu.tar.gz ~/litecoin/litecoin-0.17.1-linux-signatures.asc | sha256sum --check
RUN tar -xzvf ~/litecoin/litecoin-0.17.1-x86_64-linux-gnu.tar.gz

FROM debian:stable-slim
COPY --from=intermediate ~/litecoin/litecoin-0.17.1-x86_64-linux/ /tmp/litecoin/
FROM ubuntu

VOLUME /output
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="America/Los_Angeles"

RUN apt-get update
RUN apt-get install -y tzdata
RUN apt-get install -y git make golang

WORKDIR /src
RUN git clone https://github.com/minio/minfs

WORKDIR /src/minfs
RUN make

RUN echo "cp ./minfs /output" > /src/copy-bins
RUN echo "cp ./mount.minfs /output" >> /src/copy-bins
RUN echo "cp ./docs/minfs.8 /output" >> /src/copy-bins
RUN echo "cp ./docs/mount.minfs.8 /output" >> /src/copy-bins
RUN chmod +x /src/copy-bins

CMD "/src/copy-bins"
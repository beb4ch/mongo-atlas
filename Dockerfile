FROM golang:1.14-alpine as builder
RUN apk update && apk add dep git bash && rm -rf /var/cache/apk/* \
  && mkdir -p /go/src/github.com/beb4ch/mongo-atlas
ADD . /go/src/github.com/beb4ch/mongo-atlas
WORKDIR /go/src/github.com/beb4ch/mongo-atlas
RUN ./build.sh
FROM alpine
RUN addgroup -S dummy && adduser -S dummy -G dummy
USER dummy
WORKDIR /dist
COPY --from=builder /go/src/github.com/beb4ch/mongo-atlas/build/matlas /dist/
WORKDIR /home/dummy
COPY --from=builder /go/src/github.com/beb4ch/mongo-atlas/build/matlas /matlas
CMD ["/matlas"]

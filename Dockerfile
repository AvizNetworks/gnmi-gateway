FROM golang:1.18-alpine

ENV INSTALL_DIR /opt/gnmi-gateway

WORKDIR "${INSTALL_DIR}"
COPY . "${INSTALL_DIR}"

RUN apk add --update make gcc g++ git openssl && \
    apk update && \
    apk upgrade && \
    apk --no-cache add curl=8.4.0-r0 && \
    make build && \
    make download && \
    make tls && \
    ./gnmi-gateway -version

CMD ["./gnmi-gateway", \
    "-TargetLoaders=json", \
    "-TargetJSONFile=./targets.json", \
    "-TargetLimit=300", \
    "-EnableGNMIServer", \
    "-OpenConfigDirectory=./oc-models/", \ 
    "-ServerTLSCert=server.crt", \
    "-ServerTLSKey=server.key"]

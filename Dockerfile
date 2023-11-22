FROM golang:1.18-alpine

ENV INSTALL_DIR /opt/gnmi-gateway

WORKDIR "${INSTALL_DIR}"
COPY . "${INSTALL_DIR}"

RUN apk add --update make gcc g++ git openssl

# Update the package index and upgrade existing packages
RUN apk update && apk upgrade

# Upgrade curl to version 8.4.0-r0 or higher
RUN apk --no-cache add curl=8.4.0-r0

RUN make build
RUN make download
RUN make tls
RUN ./gnmi-gateway -version

CMD ["./gnmi-gateway", \
    "-TargetLoaders=json", \
    "-TargetJSONFile=./targets.json", \
    "-TargetLimit=300", \
    "-EnableGNMIServer", \
    "-OpenConfigDirectory=./oc-models/", \ 
    "-ServerTLSCert=server.crt", \
    "-ServerTLSKey=server.key"]

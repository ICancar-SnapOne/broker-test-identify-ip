#!/bin/sh

YAML_DIR="broker-test-identify-ip"
OUT_DIR="release"
DESTINATION_DIR=$OUT_DIR
DRIVER_VERSION="1"

rm -rf $OUT_DIR

build() {
    build/driver-packager -l build --configuration-file $YAML_DIR/driver.yaml --output-folder $DESTINATION_DIR --version $2 --build-configuration $1
}

build production ${1:-$DRIVER_VERSION}

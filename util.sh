#!/usr/bin/bash

build_spec() {
    cd $1
    spectool -g $1.spec
    mock --buildsrpm --spec $1.spec --sources . --resultdir ./_mock
    mock --rebuild ./_mock/*.src.rpm --resultdir ./_mock
    cp ./_mock/*.rpm /output
}

download_koji_sources() {
    # Takes full koji build name as input
    START_DIR=$PWD
    mkdir -p /tmp/koji-download && cd /tmp/koji-download
    koji download-build --arch=src $1
    rpmdev-extract $1.src.rpm
    mv -n $1.src/* $START_DIR
    cd $START_DIR
}
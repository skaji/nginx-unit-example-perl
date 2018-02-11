#!/bin/bash

set -eu

PERL_VERSION=5.26.1
BUILD_DIR=.build
TOP_DIR=$(cd $(dirname $0) >/dev/null 2>&1; pwd)
LOG_FILE=$BUILD_DIR/build.log

build_perl() {
  if [[ ! -f perl-$PERL_VERSION.tar.gz ]]; then
    wget -q https://www.cpan.org/src/5.0/perl-$PERL_VERSION.tar.gz
  fi
  rm -rf perl-$PERL_VERSION
  tar xzf perl-$PERL_VERSION.tar.gz
  cd perl-$PERL_VERSION
  ./Configure -Dprefix=$TOP_DIR/perl -Duseshrplib -Dman1dir=none -Dman3dir=none -DDEBUGGING=-g -des
  make -j9 install
}

install_plack() {
  curl --compressed -sSL https://git.io/cpm | $TOP_DIR/perl/bin/perl - install -g Plack
}

build_nginx_unit() {
  ./configure
  ./configure perl --perl=$TOP_DIR/perl/bin/perl
  make -j9
  make -j9 perl
}

info() {
  echo "---> $1"
}


cd $TOP_DIR
info "NOTE: You can see progress at $LOG_FILE"
if [[ ! -d perl ]]; then
  if [[ ! -d $BUILD_DIR ]]; then
    mkdir $BUILD_DIR
  fi
  info "1/4. Building perl-$PERL_VERSION"
  ( exec >> $LOG_FILE 2>&1; cd $BUILD_DIR && build_perl )
  info "2/4. Installing Plack"
  ( exec >> $LOG_FILE 2>&1; install_plack )
fi

if [[ ! -d unit ]]; then
  info "3/4. Cloning nginx/unit"
  git clone -q https://github.com/nginx/unit
fi

if [[ -f unit/build/unitd ]]; then
  exit
fi

logfile=$BUILD_DIR/build-nginx-unit.log
info "4/4. Building nginx/unit"
( exec >> $LOG_FILE 2>&1; cd unit && build_nginx_unit )

#!/bin/bash

set -x 
export LIB_NAME="openmpi"
export LIB_VERSION=2.1.1
export GCC_VERSION=6.4.0

export LIB_FULLNAME=${LIB_NAME}-${LIB_VERSION}
export GCC_VERSION_SHORT="${GCC_VERSION//.}"
export SUB_DIR=${LIB_NAME}/${LIB_VERSION}/gcc-${GCC_VERSION}
WORK_DIR=/data/software/sources/${SUB_DIR}
SRC_DIR=${WORK_DIR}/${LIB_FULLNAME}
ARCHIVE=${SRC_DIR}.tar.gz
URL="https://www.open-mpi.org/software/ompi/v2.1/downloads/${LIB_NAME}-${LIB_VERSION}.tar.gz"
BUILD_DIR=${WORK_DIR}/${LIB_FULLNAME}-build
export INSTALL_DIR=/data/software/install/${SUB_DIR}
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODULE_DIR=/data/software/modules/mpi/${LIB_NAME}
MODULE_PATH=${MODULE_DIR}/${LIB_VERSION}_gcc${GCC_VERSION_SHORT}

module load gcc/6.4.0

gcc --version

if [[ ! -f $ARCHIVE ]]; then
  mkdir -p $WORK_DIR
  wget $URL -O $ARCHIVE
fi

if [[ ! -d $SRC_DIR ]]; then
  tar zxf $ARCHIVE --directory $WORK_DIR
fi

if [[ ! -d $BUILD_DIR ]]; then
  mkdir $BUILD_DIR
  cd $BUILD_DIR
  ${SRC_DIR}/configure \
  --prefix=${INSTALL_DIR}
fi

cd $BUILD_DIR
make -j || exit 1
make -j install || exit 1

cd $SCRIPT_DIR
mkdir -p ${MODULE_DIR}
envtpl  --keep-template -o $MODULE_PATH module.tmpl

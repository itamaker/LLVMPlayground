SOURCE_DIR:=${shell dirname ${realpath ${lastword ${MAKEFILE_LIST}}}}
LLVM_SOURCE_DIR=${SOURCE_DIR}/external/llvm

BUILD_DIR := ${SOURCE_DIR}/build
LLVM_BUILD_DIR := ${BUILD_DIR}/llvm
PLAYGROUND_BUILD_DIR := ${BUILD_DIR}/playground

GIT := git
CMAKE := cmake

all:	submodule-init \
			configure-llvm build-llvm \
			configure-playground build-playground

dev: configure-playground build-playground

submodule-init:
	${GIT} submodule update --init --recursive

configure-llvm:
	mkdir -p ${LLVM_BUILD_DIR}
	${CMAKE} \
		-H${LLVM_SOURCE_DIR} \
		-B${LLVM_BUILD_DIR} \
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Debug \
		-DLLVM_ENABLE_ASSERTIONS=On \
		-DLLVM_TARGETS_TO_BUILD="X86"

build-llvm:
	${CMAKE} --build ${LLVM_BUILD_DIR}

configure-playground:
	mkdir -p ${PLAYGROUND_BUILD_DIR}
	${CMAKE} \
		-H${SOURCE_DIR} \
		-B${PLAYGROUND_BUILD_DIR} \
		-DLLVM_CMAKE_CONFIG_PATH=${LLVM_BUILD_DIR}/lib/cmake/llvm \
		-G Ninja

build-playground:
	${CMAKE} --build ${PLAYGROUND_BUILD_DIR}

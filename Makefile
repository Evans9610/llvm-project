LLVM_DIR = ${CURDIR}/llvm
BUILD_DIR = ${CURDIR}/build

all: debug

llvm: llvm-config
	(cd ${BUILD_DIR} && make -j`nproc`)

debug: llvm-debug
	(cd ${BUILD_DIR} && make -j`nproc`)

llvm-config: ${BUILD_DIR}
	(cd ${BUILD_DIR} && \
		CC=clang CXX=clang++ cmake -DLLVM_ENABLE_DUMP=ON -DLLVM_ENABLE_DOXYGEN=On -DLLVM_ENABLE_PROJECTS="clang;compiler-rt" -G "Unix Makefiles" \
		-DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release ${LLVM_DIR})

llvm-debug: ${BUILD_DIR}
	(cd ${BUILD_DIR} && \
		CC=clang CXX=clang++ cmake -DLLVM_ENABLE_DUMP=ON -DLLVM_ENABLE_DOXYGEN=ON -DLLVM_ENABLE_PROJECTS="clang;compiler-rt" -G "Unix Makefiles" \
		-DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_OPTIMIZED_TABLEGEN=OFF \
		-DCMAKE_BUILD_TYPE=Debug -DCOMPILER_RT_DEBUG=ON --enable-debug-symbols ${LLVM_DIR})

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

clean:
	rm -rf ${BUILD_DIR}

.phony:
	clean llvm llvm-config llvm-debug debug


#-------------------------------------------------------------------------------
# @author           Jean-David Gadina
# @copyright        (c) 2020, Jean-David Gadina - www.xs-labs.com
#-------------------------------------------------------------------------------

TARGETS     := "X86;AArch64;ARM"
PROJECTS    := "clang;clang-tools-extra;compiler-rt"

.PHONY: all clean distclean llvm_checkout llvm_update configure build install

.NOTPARALLEL:

all: llvm_checkout llvm_update configure build install
	
	@:
	
clean:
	
	@echo "*** Cleaning all build files"
	@rm -rf build/*

distclean: clean
	
	@echo "*** Cleaning all temporary files"
	@rm -rf source/*

llvm_checkout:

	@echo "*** Checking out LLVM"
	@if [ ! -d source/llvm-project ]; then git clone https://github.com/llvm/llvm-project.git source/llvm-project; fi
	
llvm_update:
	
	@echo "*** Updating LLVM"
	@cd source/llvm-project && git pull

configure:
	
	@echo "*** Configuring LLVM"
	@cd build && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local/llvm -DLLVM_ENABLE_PROJECTS=$(PROJECTS) -DLLVM_TARGETS_TO_BUILD=$(TARGETS) ../source/llvm-project/llvm

build:
	
	@echo "*** Building LLVM"
	@cd build && $(MAKE)

install:
	
	@echo "*** Installing LLVM"
	@cd build && $(MAKE) install

# This Makefile is for development only.  It requires cabal-dev.
# To get started, do 'make prep' and then 'make' or 'make quick'.

.PHONY: prep, submodules, all, quick, bench, clean, veryclean, install

all:
	cabal-dev configure --enable-tests --enable-benchmarks && cabal-dev build

prof:
	cabal-dev configure --enable-tests --enable-library-profiling --enable-executable-profiling && cabal-dev build

prep: pandoc-types submodules
	(cabal-dev --version || (cabal update && cabal install cabal-dev)) && \
	cabal-dev update && \
	(cd pandoc-types && git pull && cd .. && cabal-dev add-source pandoc-types) && \
	cabal-dev install --reinstall --force-reinstall pandoc-types citeproc-hs && \
	cabal-dev install-deps --enable-library-profiling --enable-tests --enable-benchmarks

submodules:
	git submodule update --init

quick:
	cabal-dev configure --enable-tests --disable-optimization && cabal-dev build

relocatable:
	cabal-dev configure -fembed_data_files && cabal-dev build

bench:
	cabal-dev configure --enable-benchmarks && cabal-dev build

clean:
	cabal-dev clean

veryclean: clean
	cabal-dev clean && rm -rf pandoc-types citeproc-hs

pandoc-types:
	git clone https://github.com/jgm/pandoc-types && \
	  cabal-dev add-source pandoc-types

citeproc-hs: pandoc-types
	darcs get --lazy http://gorgias.mine.nu/repos/citeproc-hs && \
	cabal-dev add-source citeproc-hs

install:
	cabal-dev install --enable-tests --enable-benchmarks

FROM garland/dockerfile-ubuntu-gnome

RUN apt-get update -y
RUN apt-get install -y gtk2.0
RUN apt-get install -y python-software-properties && apt-get install -y apt-file && apt-file update && apt-file search add-apt-repository && apt-get install -y software-properties-common
RUN add-apt-repository ppa:avsm/ppa && apt-get -y update && apt-get -y install ocaml ocaml-native-compilers camlp4-extra opam

RUN apt-get install -y make m4 pkg-config
RUN opam init && eval `opam config env` && opam install proverif && opam depext proverif
RUN echo '. ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true' >> ~/.bashrc

RUN apt-get install -y git build-essential python
WORKDIR /
RUN git clone https://github.com/Z3Prover/z3.git
WORKDIR z3
RUN python scripts/mk_make.py && cd build && make && sudo make install
RUN apt-get install -y curl
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN apt-get install -y libncurses5-dev libncursesw5-dev
RUN apt-get install -y openjdk-7-jdk
WORKDIR ../
RUN git clone https://github.com/GaloisInc/saw-script.git
WORKDIR saw-script
RUN ln -s stack.ghc-8.2-unix.yaml stack.yaml
RUN apt-get install -y zip
RUN ./build.sh
RUN ln -s $(stack path --local-install-root)/bin/* /usr/local/bin

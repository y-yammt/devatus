FROM ubuntu:16.04
MAINTAINER Yuji Yamamoto <y.yammt+github -a-t- gmail.com>

ENV JUBATUS_CORE_URL=https://github.com/jubatus/jubatus_core.git \
    JUBATUS_CORE_BRANCH=master \
    JUBATUS_URL=https://github.com/jubatus/jubatus.git \
    JUBATUS_BRANCH=master

RUN apt-get update; apt-get -y upgrade; apt-get -y install build-essential automake pkg-config libtool git wget g++ python python-dev ruby ruby-dev swig libmsgpack-dev libonig-dev liblog4cxx10-dev libonig-dev

RUN git clone https://github.com/jubatus/jubatus-mpio.git;\
    cd jubatus-mpio; ./bootstrap; ./configure; make; make install; cd ..

RUN git clone https://github.com/jubatus/jubatus-msgpack-rpc;\
    cd jubatus-msgpack-rpc/cpp; ./bootstrap; ./configure; make; make install; cd ../../

RUN git clone -b ${JUBATUS_CORE_BRANCH} ${JUBATUS_CORE_URL};\
    cd jubatus_core; ./waf configure; ./waf build; ./waf --checkall; ./waf install; ldconfig; cd ..

RUN git clone -b ${JUBATUS_BRANCH} ${JUBATUS_URL};\
    cd jubatus; ./waf configure; ./waf build; ./waf --checkall; ./waf install; ldconfig; cd ..

RUN apt-get -y install apt-file; apt-file update; apt-file search add-apt-repository; apt-get -y install software-properties-common;\
    add-apt-repository --yes ppa:avsm/ppa; apt-get update -qq; apt-get install -y opam; yes | opam init --root=/usr/local/opam;\
    eval $(opam config env --root=/usr/local/opam);\
    opam install -y ocamlfind extlib omake ounit ppx_deriving;\
    cd jubatus/tools/jenerator; omake; omake install; cp src/jenerator /usr/local/bin; cd /


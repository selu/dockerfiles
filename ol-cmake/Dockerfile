FROM oraclelinux:7

RUN yum-config-manager --enable ol7_optional_latest && \
    yum install -y \
	libssh2-devel \
	json-glib-devel \
	cmake \
	make \
	gcc-c++ && \
    yum clean all

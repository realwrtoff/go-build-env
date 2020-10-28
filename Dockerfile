FROM centos:centos7

RUN yum reinstall -y glibc-common && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
RUN yum install -y kde-l10n-Chinese epel-release docker-io make git gcc wget glibc-headers gcc-c++ go

# behave support
RUN yum install -y python36 python36-setuptools python36-pip
COPY requirements.txt /requirements.txt
RUN pip3 install --upgrade pip && \
    pip3 install --user -r /requirements.txt -i http://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn

ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# golang env
ENV GOPROXY=https://goproxy.cn
ENV GOPATH=/gopath
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:$GOBIN:${GOPATH}/protobuf/bin
ENV GO111MODULE=on

# protoc
RUN wget https://github.com/google/protobuf/releases/download/v3.2.0/protobuf-cpp-3.2.0.tar.gz && \
    tar -xzvf protobuf-cpp-3.2.0.tar.gz && \
    cd protobuf-3.2.0 && \
    ./configure --prefix=${GOPATH}/protobuf && \
    make -j8 && \
    make install

# grpc & grpc-gateway
RUN go get -u google.golang.org/grpc && \
    go get -u github.com/golang/protobuf/protoc-gen-go && \
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway && \
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger && \
    go get github.com/gogo/protobuf/proto && \
    go get github.com/gogo/protobuf/jsonpb && \
    go get github.com/gogo/protobuf/protoc-gen-gogo && \
    go get github.com/gogo/protobuf/gogoproto && \
    go get github.com/gogo/protobuf/protoc-gen-gofast



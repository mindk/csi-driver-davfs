FROM alpine:3.7
RUN apk add --no-cache davfs2
COPY bin/davfsplugin /davfsplugin
ENTRYPOINT ["/davfsplugin"]

# RUN mkdir -p /mnt/volumes
# RUN echo -e $'\
# dav_user        root\n\
# dav_group       root\n\
# kernel_fs       fuse\n\
# buf_size        16\n\
# connect_timeout 10\n\
# read_timeout    30\n\
# retry           10\n\
# max_retry       300\n\
# dir_refresh     30\n\
# file_refresh    10\n\
# ' >> /etc/davfs2/davfs2.conf
# COPY --from=builder /go/bin/csi-webdav /usr/local/bin
# RUN echo $PATH
# RUN ls -lisa

# FROM centos:7.4.1708
# COPY bin/davfsplugin /davfsplugin
# RUN yum -y install fuse-davfs2
# ENTRYPOINT ["/davfsplugin"]

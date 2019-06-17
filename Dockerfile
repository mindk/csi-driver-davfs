FROM alpine:3.7
RUN apk add --no-cache davfs2
COPY bin/davfsplugin /davfsplugin
ENTRYPOINT ["/davfsplugin"]

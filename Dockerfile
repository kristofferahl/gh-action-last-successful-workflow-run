FROM alpine:3.11
RUN apk update && apk add \
  bash \
  jq \
  curl
RUN bash --version
RUN jq --version
RUN curl --version
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

#TODO: Apache license

FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY ./appliance .

CMD ["./appliance"]

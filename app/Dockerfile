FROM nginx:alpine

RUN apk add --no-cache curl

WORKDIR /usr/share/nginx/html

COPY src/ .

COPY nginx.conf /etc/nginx/conf.d/default.conf
FROM nginx:alpine

RUN apk add --no-cache curl

WORKDIR /usr/share/nginx/html

COPY src/ .

# TODO: custom nginx configuration: enhancement for later
# COPY nginx.conf /etc/nginx/conf.d/default.conf
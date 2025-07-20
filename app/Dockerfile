FROM nginx:alpine

RUN apk add --no-cache curl

WORKDIR /usr/share/nginx/html

COPY src/ .

# COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf.template /etc/nginx/nginx.conf.template

CMD ["/bin/sh", "-c", "envsubst '$$APP_ENV' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]
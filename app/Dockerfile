FROM nginx:alpine

RUN apk add --no-cache curl

WORKDIR /usr/share/nginx/html

COPY src/ .

# COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf.template  /etc/nginx/conf.d/default.conf.template

CMD ["/bin/sh", "-c", "\
  envsubst '$$APP_ENV' < /usr/share/nginx/html/env.html.template > /usr/share/nginx/html/env.html && \
  envsubst '$$APP_ENV' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && \
  nginx -g 'daemon off;'"]
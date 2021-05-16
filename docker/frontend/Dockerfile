FROM node:16-slim as build-stage
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

FROM nginxinc/nginx-unprivileged:stable-alpine as production-stage
USER root
RUN apk add sed
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY --from=build-stage --chown=101:nginx /app/build /var/www/html
COPY ./docker/frontend/default.conf /etc/nginx/conf.d/
COPY ./docker/frontend/entrypoint.sh /entrypoint.sh
USER 101
EXPOSE 3000
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["nginx"]
ARG NODE_VERSION=16.20.2
FROM node:${NODE_VERSION}-alpine as base
EXPOSE 3000
ENV PROJECT_ENV production
WORKDIR /usr/app/src

FROM base as prod
ADD . /usr/app/src
RUN npm install && npm run build && npm install -g http-server
CMD http-server ./public -p 3000
FROM node:alpine
ENV PROJECT_ENV production
WORKDIR /usr/app/src
ADD . /usr/app/src
RUN npm install && npm run build && npm install -g http-server
EXPOSE 3000
CMD http-server ./public -p 3000
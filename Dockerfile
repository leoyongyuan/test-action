# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

# ARG NODE_VERSION=16.20.2

# FROM node:${NODE_VERSION}-alpine as base
# WORKDIR /usr/app
# EXPOSE 3000

# FROM base as dev
# RUN --mount=type=bind,source=package.json,target=package.json \
#     --mount=type=bind,source=package-lock.json,target=package-lock.json \
#     --mount=type=cache,target=/root/.npm \
#     npm ci --include=dev
# USER node
# COPY . .
# CMD npm run dev

# FROM base as prod
# RUN --mount=type=bind,source=package.json,target=package.json \
#     --mount=type=bind,source=package-lock.json,target=package-lock.json \
#     --mount=type=cache,target=/root/.npm \
#     npm ci --omit=dev
# USER node
# COPY . .
# CMD node src/index.js

# FROM base as test
# ENV NODE_ENV test
# RUN --mount=type=bind,source=package.json,target=package.json \
#     --mount=type=bind,source=package-lock.json,target=package-lock.json \
#     --mount=type=cache,target=/root/.npm \
#     npm ci --include=dev
# USER node
# COPY . .
# RUN npm run test
ARG NODE_VERSION=16.20.2

# 阶段一：构建可执行文件
FROM node:${NODE_VERSION}-alpine as builder
WORKDIR /usr/src/app

# 复制 package.json 和 package-lock.json，并安装依赖
COPY package*.json ./
RUN npm ci

# 复制源代码，并编译成可执行文件
COPY . .
RUN npm run build


# 阶段二：生产镜像
FROM node:${NODE_VERSION}-alpine as prod
WORKDIR /usr/app

# 复制编译好的代码到生产镜像中
COPY --from=builder /usr/src/app/dist ./dist

# 设置容器启动命令
CMD ["node", "dist/index.js"]
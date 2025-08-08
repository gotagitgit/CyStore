FROM node:18-alpine AS build
WORKDIR /app
COPY src/Store/store.webreact/package*.json ./
RUN npm ci
COPY src/Store/store.webreact/ .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 7000
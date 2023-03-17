# stage1 as builder
FROM node:18.2.0-alpine as builder
COPY package*.json ./
RUN npm install --silent
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY . ./
RUN npm run build
# stage 2
FROM nginx:alpine
# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html
# EXPOSE docker host:docker container
EXPOSE 3000 80
RUN npm run serve -s

# to execute in /iotapp:
## docker build -t appimg .
## docker run -d --name appcontainer -p 3000:80 appimg
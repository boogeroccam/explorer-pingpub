# docker image for yarn and vite:
FROM node:20.5.1-alpine as build

WORKDIR /app

# Install yarn
RUN apk add yarn

# copy the package.json and yarn.lock file
COPY package.json yarn.lock ./

# install the dependencies
RUN yarn

# copy the source code
COPY . .

# build the app
RUN yarn build

FROM nginx:stable-alpine

# copy the dist folder from build to nginx
COPY --from=build /app/dist /usr/share/nginx/html

COPY ./docker/nginx/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# expose port 80
EXPOSE 80

# start nginx server
CMD ["nginx", "-g", "daemon off;"]

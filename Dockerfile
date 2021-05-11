#Build Stage Start

#Specify a base image
FROM node:12-alpine as builder 

RUN apk add --no-cache git

#Specify a working directory
WORKDIR '/app'

#Copy the dependencies file
COPY package.json .

#Install dependencies
RUN npm install

#Copy remaining files
COPY . .

#Build the project for production
RUN npm run build 

# #Run Stage Start
FROM nginx:alpine

#Copy production build files from builder phase to nginx
COPY --from=builder /app/build /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

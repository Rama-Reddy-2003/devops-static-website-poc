# Use lightweight Nginx web server image
FROM nginx:alpine

# Copy static content into Nginx web server directory
COPY index.html /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80

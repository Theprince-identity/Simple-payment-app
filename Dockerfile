# Use a lightweight web server to serve the HTML file
FROM nginx:alpine

# Copy the HTML file to the NGINX web directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to access the web server
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]


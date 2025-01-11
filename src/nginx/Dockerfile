FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html
COPY .htpasswd /etc/nginx/.htpasswd
EXPOSE 8198
LABEL shutdown=true
CMD ["nginx", "-g", "daemon off;"]

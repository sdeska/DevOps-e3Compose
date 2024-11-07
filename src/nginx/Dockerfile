FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html
COPY .htpasswd /etc/nginx/.htpasswd
EXPOSE 8198
CMD ["nginx", "-g", "daemon off;"]

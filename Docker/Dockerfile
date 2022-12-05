FROM debian:latest
RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx -y
EXPOSE 80
# Comando para iniciar o NGINX no Container
CMD ["nginx", "-g", "daemon off;"]
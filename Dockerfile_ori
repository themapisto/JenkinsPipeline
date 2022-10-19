FROM ubuntu:18.04
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN apt upgrade -y
RUN apt-get update -y
RUN apt-get install nginx -y
WORKDIR /usr/share/nginx/html
RUN ["/bin/bash", "-c", "echo hello > index.html"]
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

CMD ["nginx"]

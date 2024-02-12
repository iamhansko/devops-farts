FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx ca-certificates wget && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 -O mkcert

RUN chmod 755 mkcert

RUN wget https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.4.0/oauth2-proxy-v7.4.0.linux-amd64.tar.gz && \
  tar xvfz oauth2-proxy-v7.4.0.linux-amd64.tar.gz && \
  mv oauth2-proxy-v7.4.0.linux-amd64/oauth2-proxy . && \
  chmod 755 oauth2-proxy

COPY ./index.html /var/www/html/

RUN echo "YOUR_EMAIL_ADDRESS_TO_ALLOW" > allowed_emails.txt

CMD nginx; \ 
  ./mkcert localhost ; \
  ./oauth2-proxy --https-address :8080 \
  --upstream http://127.0.0.1/ \
  --client-id YOUR_CLIENT_ID \
  --client-secret YOUR_CLIENT_SECRET \
  --email-domain="*" \
  #--authenticated-emails-file="allowed_emails.txt" \
  --cookie-secret=1234567890123456 \
  --tls-cert-file=localhost.pem \
  --tls-key-file=localhost-key.pem
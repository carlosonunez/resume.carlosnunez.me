FROM node:16-alpine
RUN apk upgrade
RUN apk add --no-cache chromium nss ca-certificates

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN mkdir -m 700 /puppeteer-working-dir
WORKDIR /puppeteer-working-dir
COPY package.json /puppeteer-working-dir
RUN yarn install
COPY print-to-pdf.js /puppeteer-working-dir
RUN chmod +x /puppeteer-working-dir/print-to-pdf.js && \
	ln -s /puppeteer-working-dir/print-to-pdf.js /usr/local/bin/print-to-pdf

ENTRYPOINT [ "print-to-pdf" ]

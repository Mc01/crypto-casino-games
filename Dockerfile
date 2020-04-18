FROM trufflesuite/ganache-cli

WORKDIR /app
COPY package.json ./package.json
RUN npm i

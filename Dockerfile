FROM node:17-alpine as builder

WORKDIR /app

COPY . .

RUN npm i
RUN npm run build

RUN rm -rf node_modules && \
  NODE_ENV=production npm i --production

FROM node:17-alpine

WORKDIR /app

COPY --from=builder /app  .

ENV HOST 0.0.0.0
EXPOSE 80

CMD [ "npm", "start" ]

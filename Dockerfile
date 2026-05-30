FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
# We don't have dependencies yet, but this is best practice for layer caching
COPY app.js .
EXPOSE 3000
CMD ["node", "app.js"]
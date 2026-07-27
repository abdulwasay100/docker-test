FROM node:22-alpine

WORKDIR /app

# Install only the packages needed to run the backend.
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the Express application into the image.
COPY src ./src

EXPOSE 5000

CMD ["npm", "start"]

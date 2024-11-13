# Use official Node.js runtime as base image
FROM node:22.9.0

# Create app directory in container
WORKDIR /usr/src/app

# Install app dependencies
# Copy package.json and package-lock.json first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Bundle app source
COPY . .

# Your app binds to port 3000
EXPOSE 3000

# Command to run your app
CMD [ "npm", "start" ]
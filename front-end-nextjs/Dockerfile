# Use the Node.js base image
# Stage 1: Build the frontend with Node.js
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./
RUN npm install  # Install all dependencies, including dev dependencies

# Copy the rest of the application code
COPY . .

# Build the Next.js application (this will create the `.next` folder)
RUN npm run build

# Stage 2: Serve the app with NGINX
FROM nginx:alpine

# Copy the build output from the builder stage
# Ensure you copy the correct Next.js build output
COPY --from=builder /app/.next /usr/share/nginx/html

# Expose port 80 for serving the app
EXPOSE 80

# Start NGINX to serve the application
CMD ["nginx", "-g", "daemon off;"]

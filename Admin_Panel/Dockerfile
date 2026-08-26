# Stage 1: Build Angular application
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --legacy-peer-deps

# Copy the rest of the application files
COPY . .

# Build the Angular application using development configuration to point to localhost API
RUN npm run build -- --configuration=development

# Stage 2: Serve the application using Nginx
FROM nginx:alpine
COPY --from=build /app/dist/coreui-free-angular-admin-template /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

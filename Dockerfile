# Use lightweight Node base image
FROM node:18-alpine

# Create app directory
WORKDIR /app

COPY app/package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy app source
COPY app/ .

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 3000

# Start app
CMD ["sh", "-c", "node index.js"]
### Step 1: Build stage
FROM golang:1.22-alpine as builder

WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
RUN update-ca-certificates

# Copy the application source code and build the binary
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o myapp

### 
## Step 2: Runtime stage
FROM scratch

# Copy only the binary from the build stage to the final image
COPY --from=builder /app/myapp /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8090

ARG RABBITMQ_URL=amqp://localhost:5672?connection_attempts=5&retry_delay=5
ARG RABBITMQ_EXCHANGE=APP_NAME
ENV RABBITMQ_URL ${RABBITMQ_URL}
ENV RABBITMQ_EXCHANGE ${RABBITMQ_EXCHANGE}

# Set the entry point for the container
ENTRYPOINT ["/myapp", "serve", "--http=0.0.0.0:8090"]
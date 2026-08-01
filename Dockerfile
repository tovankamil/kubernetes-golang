# Stage 1: Build the Go application
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Download Go modules
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application (disable CGO for alpine compatibility)
RUN CGO_ENABLED=0 GOOS=linux go build -o /kubernetes-golang

# Stage 2: Create a minimal image
FROM gcr.io/distroless/static-debian12

WORKDIR /

# Copy the binary from the builder stage
COPY --from=builder /kubernetes-golang /kubernetes-golang

# Expose port 8080
EXPOSE 8080

# Run the binary
ENTRYPOINT ["/kubernetes-golang"]

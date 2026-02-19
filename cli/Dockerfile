# Stage 1: Builder
FROM golang:1.26-alpine AS builder

WORKDIR /build
# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Compile a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o gitops-cli ./main.go

# Stage 2: Runtime (Scratch)
# scratch is an empty Docker image. It contains no OS and no shell
FROM scratch

WORKDIR /app
# Copy the compiled binary from the builder
COPY --from=builder /build/gitops-cli .

# Execute the binary. Default to health check.
ENTRYPOINT ["/app/gitops-cli"]
CMD ["health"]
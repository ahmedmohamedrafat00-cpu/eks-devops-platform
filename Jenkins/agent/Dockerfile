# ===============================
# Stage 1: Tools layer
# ===============================
FROM alpine:3.19 AS tools

RUN apk add --no-cache \
    curl \
    bash \
    git \
    openssh \
    ca-certificates \
    python3 \
    py3-pip \
    aws-cli \
    kubectl \
    helm


# ===============================
# Stage 2: Kaniko executor
# ===============================
FROM gcr.io/kaniko-project/executor:debug

USER root

# Copy all tools from alpine stage
COPY --from=tools / /

WORKDIR /workspace

ENTRYPOINT ["/kaniko/executor"]

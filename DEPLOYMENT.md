# Deployment Guide — deployready-amalitech

## 1. Cloud Provider

AWS EC2 was used for deployment.

### Why AWS:
- Free-tier eligible (t3.micro)
- Easy VM-based setup
- Industry standard for DevOps workflows
- Simple SSH automation integration

---

## 2. Virtual Machine Setup

- Instance: t3.micro
- OS: Ubuntu 22.04
- Public IP-based deployment (no domain)

Installed:
- Docker
- Docker CLI

Docker installation:

sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu

---

## 3. Security Configuration

AWS Security Group rules:

- HTTP (80): Open to all (0.0.0.0/0)
- SSH (22): Restricted to personal IP only

No reverse proxy is used. Docker directly exposes port 80 → 3000.

---

## 4. CI/CD Deployment Process

GitHub Actions handles deployment automatically.

Pipeline steps:

- Run tests
- Build Docker image
- Push image to GHCR
- SSH into EC2
- Pull image
- Stop old container
- Start new container

Deployment command:

docker pull ghcr.io/deployready-amalitech:<sha-tag>

docker stop kora-api || true
docker rm kora-api || true

docker run -d \
  --name kora-api \
  -p 80:3000 \
  -e PORT=3000 \
  ghcr.io/deployready-amalitech:<sha-tag>

---

## 5. How to Verify Deployment

curl http://51.20.41.5/health

Expected response:

{ "status": "ok" }

---

## 6. Logs & Debugging

View logs:

docker logs kora-api

Live logs:

docker logs -f kora-api

---

## 7. Secrets Management

Stored securely in GitHub Secrets:

- SERVER_IP
- SSH_PRIVATE_KEY
- GITHUB_TOKEN (auto-provided)

No secrets are stored in the repository.

---

## 8. IAM / Access Design

- SSH key-based authentication only
- No public SSH exposure
- Minimal access principle applied

---

## 9. Limitations

- No reverse proxy (Nginx not used)
- No rollback automation
- No monitoring/alerting system
- No Infrastructure-as-Code (Terraform not used)

---

## 10. Conclusion

This deployment demonstrates a full CI/CD pipeline from code commit to production deployment using Docker, GitHub Actions, and AWS EC2 with SSH-based automation.
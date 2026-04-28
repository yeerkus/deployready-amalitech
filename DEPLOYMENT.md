# Deployment Guide — Kora Analytics DevOps Pipeline

## 1. Overview

This project deploys a Node.js API using a fully automated CI/CD pipeline built with GitHub Actions.  
The application is containerized using Docker and deployed to an AWS EC2 virtual machine.

On every push to the `main` branch, the pipeline runs tests, builds a Docker image, pushes it to GitHub Container Registry (GHCR), and deploys it to the server via SSH.

---

## 2. Cloud Provider

I used **Amazon Web Services (AWS EC2)** with a **t3.micro Ubuntu 22.04 instance**.

### Why AWS:
- Free-tier compatible instance
- Industry-standard cloud platform
- Simple VM-based deployment suitable for small services
- Easy SSH-based automation from GitHub Actions
- Plus, I've worked with AWS before at my internship at AMAZON.COM

---

## 3. Virtual Machine Setup

The EC2 instance was configured as follows:

- OS: Ubuntu 22.04
- Instance type: t3.micro
- Public access: IP-based (no domain used)
- Docker installed manually on the VM

### Docker installation:

```bash
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
```

## 4. Networking & Security Configuration

AWS Security Group rules:

- HTTP (port 80): Open to 0.0.0.0/0
- SSH (port 22): Restricted to my personal IP only

Port mapping

- Host port 80 is mapped directly to container port 3000.

No reverse proxy (such as Nginx) was used. The application is exposed directly via Docker port mapping.

## 5. CI/CD Pipeline (GitHub Actions)

The CI/CD pipeline runs automatically on every push to the main branch.

Pipeline flow:
1. Checkout repository
2. Install dependencies
3. Run tests (npm test)
4. Build Docker image tagged with commit SHA
5. Push image to GitHub Container Registry (GHCR)
6. SSH into EC2 instance
7. Pull latest image
8. Stop and remove existing container
9. Start updated container

Deployment step executed on server:

```bash
docker pull ghcr.io/deployready-amalitech:<commit-sha>
docker stop kora-api || true
docker rm kora-api || true

docker run -d \
--name kora-api \
-p 80:3000 \
-e PORT=3000 \
ghcr.io/deployready-amalitech:<commit-sha>
```
## 6. Secrets Management

No secrets are stored in the repository.

GitHub Actions secrets used:

- SERVER_IP
- SSH_PRIVATE_KEY
- GITHUB_TOKEN (automatically provided by GitHub Actions)

## 7. How to Verify Deployment

To verify the service is running:

```bash
curl http://51.20.41.5/health
```
Expected response:
```bash
{ "status": "ok" }
```
## 8. Logging & Debugging

View container logs:

```bash
docker logs kora-api
```
Follow live logs:
```bash
docker logs -f kora-api
```
## 9. Design Decisions

- Docker ensures consistent runtime environments across local and production
- GitHub Actions automates testing and deployment
- SSH-based deployment was chosen for simplicity and transparency
- Commit SHA tagging ensures immutable deployments
- Direct port mapping avoids unnecessary complexity like reverse proxies

## 10. Limitations & Future Improvements

- No reverse proxy (could be improved using Nginx for production hardening)
- No rollback strategy for failed deployments
- No monitoring/alerting system (e.g. CloudWatch, Prometheus)
- No infrastructure-as-code (Terraform not implemented)

## 11. Conclusion

This system provides a complete CI/CD pipeline from code commit to production deployment with minimal manual intervention. Therefore, this is a solid base to develop a modern app
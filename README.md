# deployready-amalitech

## 1. Overview

This project is a containerized Node.js API deployed using a fully automated CI/CD pipeline.

It demonstrates:
- Docker containerization
- GitHub Actions CI/CD pipeline
- Cloud deployment on AWS EC2
- Automated deployment via SSH
- Health-check monitoring endpoint

Live service:

- http://51.20.41.5/health

---

## 2. What the API Does

The API exposes three endpoints:

- GET /health → returns service status
- GET /metrics → returns uptime and memory usage
- POST /data → echoes request payload

---

## 3. Local Setup

To run locally:

cd app
npm install
npm start

Or using Docker:

docker compose up --build

---

## 4. Architecture Overview

- Application: Node.js API
- Containerization: Docker
- CI/CD: GitHub Actions
- Registry: GitHub Container Registry (GHCR)
- Cloud: AWS EC2 (Ubuntu 22.04)
- Deployment: SSH-based automated pull and run

---

## 5. CI/CD Flow

On every push to main:

1. Run tests
2. Build Docker image
3. Push image to GHCR
4. SSH into EC2
5. Pull latest image
6. Restart container

---

## 6. Key Design Decisions

- Docker used for environment consistency
- GitHub Actions used for automation
- SSH deployment used for simplicity
- Commit SHA tagging used for immutable builds

---

## 7. Submission Checklist

- Docker Compose works locally
- CI pipeline runs successfully
- `/health` returns OK on public IP
- No secrets committed
- Clean commit history
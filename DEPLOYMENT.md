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
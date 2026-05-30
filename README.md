# Automated CI/CD Pipeline & Reverse Proxy Architecture

This repository contains the backend code for a Node.js Chat Application and the Infrastructure-as-Code (IaC) to automatically deploy it to a self-hosted production environment.

## 🏗️ Architecture Overview

The goal of this project was to move away from PaaS providers (like Heroku or Vercel) and build a bare-metal, automated deployment pipeline from scratch. 

Whenever code is pushed to the `main` branch, a self-hosted GitHub Actions runner intercepts the job, pulls the latest code, rebuilds the Docker containers locally, and safely restarts the application behind an Nginx reverse proxy.

### Flow of Traffic
`User -> HTTP (Port 80) -> Nginx Reverse Proxy -> Docker Network -> Node.js API (Port 3000)`

## 🛠️ Tech Stack

* **Application:** Node.js, Express
* **Containerization:** Docker, Docker Compose
* **CI/CD:** GitHub Actions (Self-Hosted Runner)
* **Web Server / Proxy:** Nginx
* **OS:** Ubuntu Server 24.04 (VirtualBox VM)

## ⚙️ Infrastructure Features

* **Self-Hosted Runner:** Bypasses GitHub's cloud limits and deploys directly to the target Linux machine. The runner is daemonized to survive server reboots.
* **Automated Docker Builds:** The pipeline uses `docker compose up -d --build` to manufacture a fresh image on every deployment, completely removing the need for manual SSH updates.
* **Reverse Proxy Shielding:** The Node.js application port (3000) is isolated from the public network. Nginx handles all incoming requests on port 80 and routes them internally, providing a layer of security and allowing for future SSL/TLS implementation.
* **Resource Management:** Automated `docker system prune -f` in the pipeline ensures the server's hard drive does not fill up with orphaned images.

## 🚀 Pipeline Execution Steps

1. Developer pushes to `main`.
2. GitHub Actions queues the `deploy.yml` workflow.
3. The daemonized runner on the Ubuntu VM picks up the job.
4. The runner fetches the latest repository state.
5. Docker Compose builds the new Node.js container image.
6. The old container is gracefully spun down, and the new one boots up.
7. Unused images are pruned.

## 📁 Repository Structure

* `src/` - Node.js application source code.
* `Dockerfile` - Multi-layer instructions for the Node container.
* `docker-compose.yml` - Orchestrates the Nginx and API containers.
* `nginx.conf` - Routing logic for the reverse proxy.
* `.github/workflows/deploy.yml` - The CI/CD automation script.

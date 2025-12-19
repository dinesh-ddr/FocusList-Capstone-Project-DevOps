# FocusList – DevOps Capstone Project

## 📌 Project Overview
FocusList is a simple web application used as part of a DevOps Capstone Project to demonstrate end-to-end DevOps practices, including Infrastructure as Code, CI/CD automation, containerization, cloud deployment, and Kubernetes orchestration.

This project focuses on **practical DevOps implementation**, troubleshooting real-world issues, and deploying a working system using AWS and open-source tools.

---

## 🧱 Architecture Overview
- Static frontend hosted using **Amazon S3 (Static Website Hosting)**
- Containerized application using **Docker**
- Infrastructure provisioned using **Terraform**
- Kubernetes cluster deployed using **Amazon EKS**
- CI/CD pipeline implemented using **Jenkins**
- Container images stored in **Amazon ECR**

---

## 🛠️ Tools & Technologies Used
- **AWS** (S3, EKS, EC2, IAM, VPC, ECR)
- **Terraform** (Infrastructure as Code)
- **Docker**
- **Kubernetes**
- **Jenkins**
- **Git & GitHub**
- **Linux (Ubuntu)**

---
## 📁 Repository Structure
FocusList-Capstone-Project-DevOps/
│
├── infra/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── modules/
│ ├── vpc/
│ ├── eks/
│ └── ecr/
│
├── app/
│ ├── index.html
│ ├── style.css
│ └── app.js
│
├── Dockerfile
├── Jenkinsfile
└── README.md

---

## 🚀 CI/CD Pipeline Flow
1. Jenkins pulls code from GitHub
2. Terraform provisions AWS infrastructure
3. EKS cluster and node group are created
4. Application image is built and pushed to ECR
5. Kubernetes cluster is verified using kubectl
6. Static frontend is hosted via S3 for testing and screenshots

---

## ⚙️ Key Implementation Details
- **Terraform modules** used for VPC, EKS, and ECR
- **Private subnets** used for EKS worker nodes
- **IAM roles and policies** configured manually in Terraform
- **Jenkins agent** configured on EC2 using SSH
- **kubectl** configured using `aws eks update-kubeconfig`

---

## 🚀 CI/CD Pipeline Flow
1. Jenkins pulls code from GitHub
2. Terraform provisions AWS infrastructure
3. EKS cluster and node group are created
4. Application image is built and pushed to ECR
5. Kubernetes cluster is verified using kubectl
6. Static frontend is hosted via S3 for testing and screenshots

---

## ⚙️ Key Implementation Details
- **Terraform modules** used for VPC, EKS, and ECR
- **Private subnets** used for EKS worker nodes
- **IAM roles and policies** configured manually in Terraform
- **Jenkins agent** configured on EC2 using SSH
- **kubectl** configured using `aws eks update-kubeconfig`

---

## 🧪 Validation & Testing
- Verified EKS nodes using:
  ```bash
  kubectl get nodes

---
  
👥 Team Members

Dinesh DR and Prashantha

---

🔒 Cleanup

All AWS resources were properly destroyed after completion to avoid unnecessary charges.


## 📁 Repository Structure

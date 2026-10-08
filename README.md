# 🚀 Production-Ready AWS Two-Tier Architecture with Terraform (IaC)

A modular, secure, and scalable **AWS Two-Tier Infrastructure** provisioned using **Terraform (Infrastructure as Code)**. This project follows AWS Well-Architected Framework principles by isolating public-facing workloads from private internal compute layers across multiple Availability Zones (`us-east-1a` & `us-east-1b`).

---

## 📌 Project Overview

This repository contains declarative Terraform code to deploy a multi-AZ AWS network architecture from scratch. It establishes network isolation between public app layers and private compute layers using custom VPC networking, route tables, security groups, and gateway configurations.

### Key Highlights
* **Multi-AZ High Availability:** Workloads are distributed across two Availability Zones (`us-east-1a` and `us-east-1b`) for fault tolerance.
* **Network Isolation:** Public subnets host public-facing application servers and NAT Gateways, while private subnets isolate sensitive compute resources.
* **Modular Code Structure:** Designed with reusable Terraform modules to enforce DRY (Don't Repeat Yourself) principles and clean state management.

---

## 🌐 Architecture Diagram

![AWS Two-Tier Architecture](./architecture-diagram.png)

### Architecture Highlights:
* **VPC CIDR:** `10.0.0.0/16`
* **Public Subnets:** 
  * `10.0.1.0/24` (AZ: `us-east-1a`)
  * `10.0.2.0/24` (AZ: `us-east-1b`)
* **Private Subnets:** 
  * `10.0.3.0/24` (AZ: `us-east-1a`)
  * `10.0.4.0/24` (AZ: `us-east-1b`)
* **Internet Access:** 
  * Inbound: Internet Gateway (IGW) attached to public subnets.
  * Outbound: Dual NAT Gateways (1 per AZ) allowing private instances secure outbound internet traffic for updates without exposing public IPs.
* **Private Connectivity:** VPC Endpoints configured for secure AWS service connectivity within the private network.
* **Security Layers:** Segregated Security Groups for application servers (`App Security Group`) and private instances (`Private Security Group`).

---

## 🛠️ Features

- [x] **Custom VPC Setup:** Full control over CIDR block allocations and subnetting.
- [x] **Subnet Segregation:** Strict boundary between public ingress/egress layers and private workloads.
- [x] **High Availability Routing:** Separate Route Tables for public and private subnets with automated NAT routing per zone.
- [x] **Fine-Grained Access Control:** Least-privilege ingress and egress rules attached via stateful Security Groups.
- [x] **Automated Compute Provisioning:** EC2 instances automatically launched into respective availability zones.
- [x] **Infrastructure as Code (IaC):** 100% automated lifecycle management (destroy/apply) using Terraform.

---

## 🧰 Technologies & Tools Used

* **Cloud Provider:** Amazon Web Services (AWS)
* **Infrastructure as Code:** Terraform (v1.x+)
* **Core AWS Services:** 
  * Virtual Private Cloud (VPC)
  * Elastic Compute Cloud (EC2)
  * Internet Gateway (IGW) & NAT Gateway
  * VPC Endpoints
  * Route Tables & Security Groups
* **Operating System:** Amazon Linux 2 / Ubuntu
* **Version Control:** Git & GitHub

---

## 📂 Repository Structure

```text
.
     # EC2 Instance configurations
├── main.tf             # Core module invocations
├── variables.tf        # Input variable definitions
├── outputs.tf          # Useful resource outputs (VPC ID, IPs)
├── terraform.tfvars    # Environment-specific configuration
└── README.md           # Project Documentation

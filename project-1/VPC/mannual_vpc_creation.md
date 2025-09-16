# AWS VPC, Subnets, Routing, and EC2 Deployment

This document explains **VPC, subnets, CIDR blocks, route tables, and internet gateways** in AWS, with examples and step-by-step instructions.  

---

## What is a VPC?
- A **Virtual Private Cloud (VPC)** is a private, isolated network in the AWS cloud.  
- It lets you securely launch and manage AWS resources.  
- You define:
  - IP address ranges (CIDR block).  
  - Subnets (public or private).  
  - Routing rules.  
  - Internet and NAT connectivity.  

---

## Regions and Availability Zones
- **Region**: A geographical location (e.g., `eu-north-1`, `us-east-1`).  
- **Availability Zone (AZ)**: Each region contains multiple isolated data centers (e.g., `us-east-1a`, `us-east-1b`).  
- VPCs span the entire region, but **subnets** exist in a single AZ.  

---

## VPC CIDR Block
- CIDR = **Classless Inter-Domain Routing**.  
- Defines the IP address range of your VPC.  
- Example: `10.0.0.0/16`.  
  - `/16` → First 16 bits are **network portion**.  
  - Remaining 16 bits → **host addresses**.  
  - Range = `10.0.0.0 – 10.0.255.255`.  
  - Total IPs = 65,536 (2^16).  

### CIDR Format
IP address / prefix length

markdown
Copy code
- Example: `192.168.1.0/24`.  
  - `/24` → First 24 bits fixed, last 8 bits for hosts.  
  - Range: `192.168.1.0 – 192.168.1.255`.  
  - Usable IPs = 254 (network + broadcast reserved).  

---

## Subnets
- Subnets divide a VPC into **smaller networks**.  
- Each subnet must belong to **one Availability Zone**.  
- You can create **public** and **private** subnets:  
  - **Public Subnet** → Connected to an Internet Gateway (IGW).  
  - **Private Subnet** → No direct Internet access, used for backend systems.  

### Example Subnet CIDR Blocks
- Public subnet: `10.0.1.0/24` → 256 IPs (254 usable).  
- Private subnet: `10.0.2.0/24` → 256 IPs (254 usable).  

### Bit Representation
Example: `10.0.1.0`  
Decimal: 10.0.1.0
Binary : 00001010.00000000.00000001.00000000
/24 → First 24 bits (network), last 8 bits (hosts)
Range: 10.0.1.0 – 10.0.1.255

yaml
## Route Tables
- A **route table** is a set of rules that decide where network traffic is directed.  
- Every subnet must be associated with a route table.  

### Example Route Table
| Destination   | Target          |
|---------------|-----------------|
| 0.0.0.0/0     | igw-xxxxxxx     |
| 10.0.0.0/16   | local           |

- `0.0.0.0/0` → Internet route via Internet Gateway.  
- `10.0.0.0/16` → Local VPC traffic.  

---

## Internet Gateway (IGW)
- Allows communication between VPC and the internet.  
- Must be attached to a VPC and linked to a route table with a `0.0.0.0/0` rule.  

---

## Security Groups
- **Virtual firewalls** for EC2 instances.  
- Define **inbound** and **outbound** rules.  
- Example: Allow SSH (`22`), HTTP (`80`), HTTPS (`443`).  

---

## Steps to Create a VPC in AWS

### 1. Create VPC
- Go to **VPC Dashboard → Create VPC**.  
- Name: `MyVPC`.  
- IPv4 CIDR block: `10.0.0.0/16`.  
- Leave default settings.  

### 2. Create Subnets
- Public Subnet → `10.0.1.0/24`, AZ = `eu-north-1a`.  
- Private Subnet → `10.0.2.0/24`, AZ = `eu-north-1a`.  

### 3. Create and Attach Internet Gateway
- Create IGW → Name: `MyVPC-IGW`.  
- Attach to `MyVPC`.  

### 4. Create Route Table
- Create new Route Table → Name: `MyPublicRT`.  
- Associate Public Subnet with this Route Table.  
- Add route:  
  - Destination: `0.0.0.0/0`.  
  - Target: Internet Gateway (`MyVPC-IGW`).  

### 5. Launch EC2 in Private Subnet
- Go to **EC2 → Launch Instance**.  
- Choose `Amazon Linux 2`.  
- Network settings:  
  - VPC: `MyVPC`.  
  - Subnet: **Private Subnet (10.0.2.0/24)**.  
  - Auto-assign public IP: **Disabled**.  
- Security Group: Allow SSH from your IP.  

---


yaml
Copy code

---

## Example CIDR Calculations
- `10.0.0.0/16` → 65,536 IPs.  
- Public Subnet (`10.0.1.0/24`) → 256 IPs.  
- Private Subnet (`10.0.2.0/24`) → 256 IPs.  

---

✅ With this configuration, you now have:
- A **VPC** with CIDR `10.0.0.0/16`.  
- One **public subnet** with internet access.  
- One **private subnet** without direct internet.  
- Route Table and IGW configured.  
- EC2 instance launched in **private subnet**.  

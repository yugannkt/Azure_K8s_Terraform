# Terraform Azure AKS Deployment

## Overview

This Terraform configuration sets up an Azure Kubernetes Service (AKS) cluster along with the required networking and security infrastructure. The deployment includes:

    1. Azure Kubernetes Service (AKS) for running containerized applications.
    
    2. Virtual Network (VNet) with multiple subnets.
    
    3. NAT Gateway to manage outbound traffic.
    
    4. Azure Application Gateway for load balancing.
    
    5. Route Table for controlling traffic flow.
    
    6. Network Security Group (NSG) for managing inbound/outbound rules.

# Module Structure

The Terraform code is structured into multiple modules to keep the configuration modular and reusable.

## 1. Resource Group
    ```
    Defined in main.tf:
    
    resource "azurerm_resource_group" "rg" {
      name     = var.rg_name
      location = var.location
    }
    ```
## 2. Virtual Network (VNet) and Subnets

Defined in modules/vnet/main.tf, it creates:

    1. A VNet
    
    2. Subnets for AKS, NAT, and Application Gateway
    
    3. An NSG with security rules
    
    4. Associations between NSG and subnets

## 3. NAT Gateway

Defined in modules/nat-gateway/main.tf, it:
    
    Creates a NAT Gateway
    
    Attaches a public IP
    
    Associates the NAT Gateway with the subnet

## 4. Route Table

Defined in modules/route-table/main.tf, it:

    Creates a route table
    
    Adds a default route to the internet
    
    Associates the route table with the AKS subnet

## 5. Azure Application Gateway

Defined in modules/app-gateway/main.tf, it:
    
    Creates an Azure Application Gateway
    
    Configures backend pools, HTTP listeners, and routing rules

## 6. Azure Kubernetes Service (AKS)

Defined in modules/aks/main.tf, it:
    
    Deploys an AKS cluster
    
    Configures networking (VNet, subnets, NSG, NAT Gateway)
    
    Enables auto-scaling
    
    Uses a system-assigned identity

## Deployment Steps

1. Initialize Terraform:
```
terraform init
```
2. Plan the deployment:
```
terraform plan
```
3. Apply the configuration:
```
terraform apply 
```
## Variables

Defined in terraform.tfvars:

    rg_name          = "aks-grp"
    location         = "Central India"
    vnet_name        = "aks-vnet"
    address_space    = ["10.0.0.0/8"]
    subnet_name      = "aks-subnet"
    subnet_address_prefixes = ["10.240.0.0/16"]
    nat_subnet_name    = "nat-subnet"
    nat_subnet_address_prefixes = ["10.0.2.0/24"]
    aks_name         = "aks-cluster"
    dns_prefix       = "aksdns"
    vm_size          = "Standard_DS3_v2"
    nsg_name         = "aks-nsg"



## Cleanup

To remove the deployment:

    terraform destroy -auto-approve

Conclusion

This Terraform setup provides a scalable and secure AKS environment on Azure with modular components for easy maintenance and expansion.


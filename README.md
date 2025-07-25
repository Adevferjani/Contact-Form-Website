# Contact Form Website - AWS Terraform Project

## 📌 Project Overview

This project deploys a **serverless contact form website** on AWS using **Terraform** for Infrastructure as Code (IaC). It leverages multiple AWS services to build a scalable, secure, and cost-efficient contact form system:

- **Amazon S3** – Static website hosting  
- **Amazon CloudFront** – Global CDN & HTTPS termination  
- **Amazon API Gateway** – API endpoint  
- **AWS Lambda** – Backend processing  
- **Amazon DynamoDB** – Data storage
> 🚧 **This project is currently under development. Features may change, and it is not a final release.**


---

## 🧭 Architecture Diagram

```
User Browser 
    ↓
CloudFront CDN 
    ↓
S3 Bucket (Static Website)


Form Submission (POST)
    ↓
API Gateway → Lambda → DynamoDB
```

---

## 🛠️ Prerequisites

- ✅ An **AWS Account** with sufficient permissions  
- ✅ **Terraform**    

---

## 🚀 Setup Instructions

### 1. Prepare Lambda Function
```bash
zip lambda_function.zip lambda_function.py
```

### 2. Configure AWS Credentials

Create a `terraform.tfvars` file:
```hcl
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"
```
> ⚠️ **Never commit this file to version control!**

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review Deployment Plan
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply
```
Type `yes` to confirm when prompted.

---

## 📁 Project Structure

```
.
├── api_gateway.tf         # API Gateway configuration
├── cloudfront.tf          # CloudFront setup
├── dynamodb.tf            # DynamoDB table for submissions
├── iam.tf                 # IAM roles and policies
├── index.html.tpl         # Website HTML template
├── lambda.tf              # Lambda deployment config
├── lambda_function.py     # Form handling logic
├── lambda_function.zip    # Zipped Lambda code (generated)
├── main.tf                # Main orchestration file
├── outputs.tf             # Output values
├── providers.tf           # AWS provider setup
├── s3.tf                  # S3 bucket configuration
├── terraform.tfvars       # AWS credentials (ignored)
└── variables.tf           # Terraform variable definitions
```

---

## 📦 Outputs

After successful deployment, Terraform will output:

- ✅ Website URL (CloudFront)  
- ✅ API Gateway Endpoint  
- ✅ DynamoDB Table Name  
- ✅ Lambda Function Name  
- ✅ S3 Bucket Name(s)  
- ✅ CloudFront Distribution ID  

---

## ✅ Testing the Contact Form

1. Visit the **Website URL** from Terraform outputs  
2. Fill out and submit the contact form  
3. Confirm the success message  
4. Check the DynamoDB table for the new entry  

---

## 🧹 Clean Up

To destroy all resources and avoid charges:

```bash
terraform destroy
```

---

## 🔐 Security Notes

- **HTTPS enforced** via CloudFront  
- **Minimal IAM permissions** for Lambda  
- **CORS restricted** to `POST` only  
- **S3 ACLs disabled** for tighter access control  
- **API Gateway** includes rate limiting  

---

## ⚙️ Customization Options

| Component       | File                 | What You Can Customize                   |
|----------------|----------------------|------------------------------------------|
| Website Design | `index.html.tpl`     | HTML, CSS, branding                      |
| Form Logic     | `lambda_function.py` | Data validation, email notifications     |
| Infrastructure | `variables.tf`       | Region, timeout, caching settings        |
| Database       | `dynamodb.tf`        | Schema, keys, indexing strategy          |

---

## 🛠️ Troubleshooting Guide

| Issue                     | Where to Check                            |
|--------------------------|-------------------------------------------|
| Form not submitting       | API Gateway logs, Lambda CloudWatch       |
| Website not loading       | CloudFront config, S3 permissions         |
| CORS errors               | API Gateway CORS settings                 |
| Data not stored           | Lambda permissions, DynamoDB config       |

---

## ☁️ AWS Services Used

| AWS Service     | Purpose                          |
|----------------|----------------------------------|
| **S3**          | Static website hosting           |
| **CloudFront**  | CDN distribution and HTTPS       |
| **API Gateway** | API endpoint                     |
| **Lambda**      | Backend function for form data   |
| **DynamoDB**    | NoSQL storage for submissions    |
| **IAM**         | Role-based access control        |
| **CloudWatch**  | Logs and monitoring              |

---

## 📬 Contact

Feel free to fork the repo, open issues, or suggest improvements via pull requests! 

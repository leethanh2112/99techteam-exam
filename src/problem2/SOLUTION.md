# Diagram:
![Castle](https://github.com/user-attachments/assets/e71b1388-1d4d-4a7f-9936-f0044a16e3b3)

## 1.AWS Shield
Why Used:
```
Provides DDoS protection to safeguard applications against volumetric and sophisticated network attacks.
Automatically integrates with AWS services such as ALB, CloudFront, and Route 53 for protection without additional configuration.
```
Alternatives Considered:
```
AWS WAF: Can provide application layer security, but it does not fully protect against large-scale DDoS attacks.
Third-party solutions (e.g., Cloudflare, Akamai Kona Site Defender): These offer advanced security but introduce external dependencies.
```

## 2.Elastic Load Balancing (ALB Public & ALB Internal)
Why Used:
```
ALB Public: Handles external HTTP/HTTPS traffic and routes requests to the frontend service running in ECS.
ALB Internal: Used for internal service-to-service communication (e.g., frontend calling backend services).
Supports path-based routing, SSL termination, and auto-scaling.
```
Alternatives Considered:
```
NLB (Network Load Balancer): Preferred for handling TCP/UDP-based workloads, but lacks advanced HTTP-based routing.
CloudFront with API Gateway: For global edge distribution, but may not be necessary for internal traffic.
```

## 3.Amazon ECS (Elastic Container Service)
Why Used:
```
Provides container orchestration to deploy, manage, and scale Docker containers.
Integrates seamlessly with AWS services like ALB, IAM, Secret Manager and CloudWatch.
Reduces overhead compared to managing Kubernetes clusters manually.
```
Alternatives Considered:
```
Amazon EKS (Elastic Kubernetes Service): More flexible but requires Kubernetes management.
AWS Lambda: Suitable for event-driven applications but not ideal for long-running services.
Self-managed Kubernetes: More control but requires infrastructure maintenance.
```

## 4.Amazon RDS Aurora (PostgreSQL)
Why Used:
```
Provides managed relational database services with automated backups, replication, and performance enhancements.
Aurora is serverless and supports auto-scaling, reducing management overhead.
```
Alternatives Considered:
```
Self-hosted PostgreSQL on EC2: More control, but requires maintenance and scaling.
```

## 5.AWS ElastiCache
Why Used:
```
Provides low-latency caching for session storage and API responses.
Reduces database load by caching frequently accessed data.
Supports Redis and Memcached for flexibility
```
Alternatives Considered:
```
CloudFront for edge caching: More useful for CDN-based caching, not application session storage.
```

## 6.AWS Secrets Manager
Why Used:
```
Securely stores sensitive information like database credentials, API keys, and encryption keys.
Provides automatic rotation and fine-grained access control via IAM.
```
Alternatives Considered:
```
Parameter Store (AWS Systems Manager): Lower-cost alternative but lacks built-in rotation features.
Vault by HashiCorp: Popular self-managed secret store, but requires additional infrastructure.
```

## 7.Amazon S3
Why Used:
```
Stores static files like application assets, logs, and backups.
Provides scalability, durability, and lifecycle management for cost optimization.
```
Alternatives Considered:
```
EFS (Elastic File System): Better for shared file systems but not for object storage.
CloudFront for global distribution: Useful if latency-sensitive content delivery is required.
```

## 8.Amazon Route 53
Why Used:
```
Provides DNS routing and domain name management.
Supports health checks and traffic routing policies (e.g., latency-based, failover).
```
Alternatives Considered:
```
Cloudflare DNS: Offers DDoS protection and additional security features.
Google Cloud DNS: A multi-cloud alternative with similar capabilities.
```

## 9.Amazon ECR (Elastic Container Registry)
Why Used:
```
Stores and manages Docker container images securely.
Provides integration with ECS, IAM-based access control, and vulnerability scanning.
```
Alternatives Considered:
```
Docker Hub: Public registry but has pull limits.
GitHub Container Registry: Suitable for GitHub-based workflows.
Self-hosted Harbor: Open-source alternative, but requires additional management.
```

## 10.VPN Gateway
Why Used:
```
Allows secure connectivity between the tech team and AWS environment.
Provides IPSec-based encrypted communication for private network access.
```
Alternatives Considered:
```
Bastion Host (Jump Server): Alternative for SSH-based access, but requires additional security measures.
Open VPN Server: Free Opensource, but requires additional infrastructure.
```

## 11.AWS KMS (Key Management Service)
Why Used:
```
Provides secure encryption key management for protecting sensitive data.
Used to encrypt data in S3, RDS (Aurora), Secrets Manager, and ElastiCache.
Supports automatic key rotation, fine-grained IAM permissions, and integration with AWS services.
```
Alternatives Considered:
```
HashiCorp Vault: Self-managed secret and encryption key storage, but requires infrastructure setup.
```

## 12.AWS Cloudwatch
Why Used:
```
Provides a place to centralize the log from Application.
```
Alternatives Considered:
```
Datadog , ELK, Prometheus Loki
```

## Plans for scaling when the product grows
As the product scales, the current AWS setup should evolve to handle increased traffic, data volume, and system complexity. Below are key areas for scalability planning with specific AWS services and alternative strategies.

# 1. Compute Scaling (ECS & Backend Services)
ECS (Elastic Container Service) manages frontend & backend microservices with auto-scaling enabled.
Each ECS Task is placed in a private subnet and uses an ALB for traffic distribution.
```
✅ Increase ECS Task Count: Configure ECS Service Auto Scaling to dynamically add/remove containers based on CPU, memory, and request count.
✅ Fargate Migration: Move to AWS Fargate to eliminate EC2 management and scale on-demand.
✅ EKS (Kubernetes) Transition: If microservices expand significantly, consider Amazon EKS for better orchestration and multi-region scaling.
```

# 2. Database Scaling (Aurora PostgreSQL)
Amazon Aurora PostgreSQL with a primary writer and read replicas.
Encrypted at rest using AWS KMS.
```
✅ Enable Aurora Auto-Scaling: Add read replicas automatically based on query volume.
✅ Multi-AZ Deployment: Ensure automatic failover with Aurora Global Database to reduce downtime.
```

# 3. API & Traffic Scaling
API requests go through ALB (Application Load Balancer), distributing traffic to ECS services.
Route 53 manages domain resolution with failover policies.

# 4. Storage Scaling (S3 & ElastiCache)
S3 stores static files (encrypted with KMS).
ElastiCache (Redis) stores user sessions for fast lookups.
```
✅ S3 Lifecycle Policies: Automate moving data to Glacier for cost savings.
✅ ElastiCache Cluster Mode: Scale Redis horizontally for large datasets.
```

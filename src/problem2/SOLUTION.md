# Diagram:
![Castle](https://github.com/user-attachments/assets/0afd5fb0-917a-423d-a51a-45a4f774ad62)

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
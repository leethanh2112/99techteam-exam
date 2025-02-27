## Troubleshooting High Memory Usage on Ubuntu 24.04 Running NGINX
## 1.Check Memory Usage Details
Run the following commands to analyze memory consumption:
```
free -h
```
This will show total, used, and free memory, including swap usage.
If swap usage is high, the system might be under memory pressure.

```
ps aux --sort=-%mem | head -10
```
Lists the top 10 processes consuming memory.
We expect NGINX to be the top process, but if there are other processes consuming high memory, we need to investigate them.

```
cat /var/log/nginx/error.log | tail -100
```
Check for errors or excessive logging.

# Recovery Steps:
Try to restart nginx
```
systemctl restart nginx
```
Kill service IDs that cause high memory usage
```
kill -9 PID
```

## 2: Excessive Client Requests / High Traffic Load
Logs show a surge in incoming traffic leading to excessive resource usage.
netstat -anp | grep ":80" shows too many connections.

Impact:
Increased response time, possible 502/504 gateway errors.
Server may become unresponsive due to memory exhaustion.

# Recovery Steps:
Add Whitelist IP to nginx configuration
```
server {
    listen 80;
    server_name example.com;

    location / {
        allow X.X.X.X;   # Allow this specific IP
        allow Y.Y.Y.Y;     # Allow another specific IP
        deny all;              # Deny all other IPs
    }
}

```
Rate Limit Requests in NGINX:
```
limit_req_zone $remote_addr zone=one:10m rate=10r/s;
server {
    location / {
        limit_req zone=one burst=20;
    }
}
```
Enable Connection Limits
```
worker_connections 2048;
keepalive_timeout 15;
```
Use Cloudflare / AWS WAF or adding Nginx instances to autoscaling group
Protect against DDoS attacks with AWS Shield or Cloudflare
Deploy additional NGINX instances and use AWS ALB / Route 53 for load balancing.


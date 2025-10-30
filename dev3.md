Access — Prometheus & Node Exporter (dev-3)

On the dev-3 (Amazon Linux 2023) instance, two public ports have been opened for monitoring:


Node Exporter 9100 Exposes system metrics 
http://13.60.189.255:9100/metrics
Prometheus 9090 Web UI for querying and monitoring metrics
http://13.60.189.255:9090

Both services are accessible online,  
and can also be accessed locally from the desktop terminal (CMD/PowerShell) using SSH:

SSH access requires the private key file beqirborova-key.pem
ssh -i beqirborova-key.pem ec2-user@13.60.189.255

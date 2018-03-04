# Containers Monitoring

Project allows to configure cluster for containers resource
usage monitoring. Cluster consists of: prometheus, grafana,
cadvisor. Also there is a simple application - terrify for
testing (is built from Dockerfile).

Terrify is able to generate terraform aws_instance and aws_key_pair
resources in 2 formats understandable by Terraform - HCL or json, for
test purpose it just prints them out in a loop.

To run cluster deployment:

docker-compose up

Grafana is provisioned with an initial dashboard containers.json
(from dashboards directory).
Next panels are available in dashboard:
- filesystem writes
- cpu (usage in seconds)
- memory (rss used)

These panels are set to track containers with names starting with
'compose_'. Default name prefix for containers is set in .env file.
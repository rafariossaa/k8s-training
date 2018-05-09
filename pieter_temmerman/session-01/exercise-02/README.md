# README
## Kubernetes Exercise-02

### Introduction

The present exercise deploys a Wordpress site with MariaDB as it's backend.
To set it up, we rely on several Kubernetes objects such as:

- Secrets
- ConfigMaps
- Deployments (and ReplicaSets)
- Services
- Ingress

### Configuring the Wordpress deployment

mariadb.properties and wordpress.properties can be modified as desired to properly configure Wordpress according to your needs.
mariadb.secrets and wordpress.secrets can be modified to change the default usernames and passwords.

It is worth noting that the above files will "automagically" be loaded as environment variables in their corresponding containers.

### How to deploy

Execute 'commands.bash'

Note: It is expected that your kubectl environment is configured correctly.
That is, it should be pointing to the correct Kubernetes API IP and use the X509 certificates to authenticate against it.

### Curiosities

Strangely enough, you can create an ingress referencing a non-existent tls-secret. Moreover, "kubectl describe ingress NAME" shows it's configured to serve HTTPS requests. This lead to some confusion (and lost time), as I wasn't aware that my tls-secret wasn't properly created.

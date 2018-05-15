# README
## Kubernetes Exercise-03

### Introduction

The present exercise deploys a Wordpress site with MariaDB as it's backend.
To set it up, we rely on several Kubernetes objects such as:

- Secrets
- ConfigMaps
- Deployments (and ReplicaSets)
- Services
- Ingress

### Configuring the Wordpress deployment

wordpress.properties can be modified as desired to properly configure Wordpress according to your needs.
mariadb.secrets and wordpress.secrets can be modified to change the default usernames and passwords.

It is worth noting that the above files will "automagically" be loaded as environment variables in their corresponding containers.

### How to deploy

Execute 'commands.bash'

Note: It is expected that your kubectl environment is configured correctly.
That is, it should be pointing to the correct Kubernetes API IP and use the X509 certificates to authenticate against it.

### Curiosities

I had some struggles getting the nginx controller to include configuration-snippets defined in the ingress yaml.
No error was returned creating the ingress, but neither were the changes incorporated in the nginx.conf file.
I really missed some kind of "output log" such as "kubectl logs" for containers.
Eventually I figured out you can pass the option "--v=LOGLEVEL" to the kubectl command, which helped me a bunch in figuring out what was going on under the hood. I will definitely use that option more often!

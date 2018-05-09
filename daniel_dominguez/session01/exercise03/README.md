# Here you can find files used in exercise 03.

## command.bash
This script executes all of the necessary steps to deploy k8s objects needed to solve exercise-03

## Most relevant aspects
1. Access to external database has been configured with service type ExternalName.
2. TLS configuration has been done generating a self-signed certificate with openssl (see command.bash). Then we have created a secret and then an ingress that uses that secret to configure HTTPS.
3. /my-custom-admin redirections has been done with the following annotation:
        nginx.ingress.kubernetes.io/configuration-snippet: |
        if ($uri ~* /my-custom-admin) {
            return 301 https://wordpress-03.35.171.157.107.nip.io/wp-admin/;
        }
although it can be done with annotation nginx.ingress.kubernetes.io/permanent-redirect this option must be placed in an additional ingress rule associated with path /my-custom-admin and this generates two locations (/ and /my-custom-admin) asociated to wordpress-03 server inside nginx.conf file.

# Setting Up a strongSwan IKEv2 VPN Server on Docker

This guide will walk you through setting up a strongSwan IKEv2 VPN server using Docker. The server will support both pre-shared keys (PSK) and certificates.

## Server Setup

### Gather Necessary Files

1. Configuration Files: Prepare your configuration files based on Quericy Eden’s blog post. These files include:
    - **ipsec.conf**: Main configuration file.
    - **ipsec.secrets**: Secrets file.
    - **strongswan.conf**: Additional configuration.
    - If you're using certificate-based authentication, also include the following files:
        - **cacerts/ca.cert.pem**: CA certificate.
        - **certs/client.cert.pem**: Client certificate.
        - **certs/server.cert.pem**: Server certificate.
        - **private/client.pem**: Client private key.
        - **private/server.pem**: Server private key.

  
2. Build the Docker image:

    ```bash
    docker build -t strongswan .
    ```

### After building the docker image
The organized files should follow the structure:
   
```
.
├── ipsec.conf
│
├── ipsec.secrets
│
├── strongswan.conf
│
├── cacerts
│   └── ca.cert.pem
│
├── certs
│   ├── client.cert.pem
│   └── server.cert.pem
│
└── private
    ├── client.pem
    └── server.pem
```

### Start Docker container

Running this particular Docker container typically requires
running with elevated privileges `--privileged`. It will have permission to
modify your Docker host's sysctl and iptables configuration.

Ensure the config folder is in your current directory ($PWD) and run:

    docker build -t strongswan https://github.com/lumbird/pi-docker-strongswan

    docker run -d \
      --restart always \
      --privileged \
      -p 500:500/udp \
      -p 4500:4500/udp \
      -v $PWD:/etc/ipsec.d \
      --name=strongswan \
      strongswan

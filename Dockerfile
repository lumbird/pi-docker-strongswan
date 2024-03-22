# Use a lightweight base image
FROM alpine:3.14

# Set the timezone to London
ENV TZ=Europe/London

# Copy necessary scripts
COPY *.sh /

# Make scripts executable
RUN chmod a+x /*.sh

# Run deployment script
RUN /deploy.sh

# Move configuration files
RUN mv /etc/ipsec.conf /etc/ipsec.secrets /etc/strongswan.conf /etc/ipsec.d/

# Create symbolic links
RUN ln -sf /etc/ipsec.d/ipsec.conf /etc/ipsec.d/ipsec.secrets /etc/ipsec.d/strongswan.conf /etc/

# Expose necessary ports
EXPOSE 500/udp 4500/udp

# Set the default command
CMD ["/boot.sh"]

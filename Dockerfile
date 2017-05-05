# GlassFish on Docker
FROM glassfish/openjdk

# Maintainer
MAINTAINER Nick Larsen <nick.larsen@aptiv.co.nz>

# Set environment variables and default password for user 'admin'
ENV GLASSFISH_PKG=glassfish-4.1.2.zip \
    GLASSFISH_URL=http://download.oracle.com/glassfish/4.1.2/release/glassfish-4.1.2.zip \
    GLASSFISH_HOME=/glassfish4 \
    PATH=$PATH:/glassfish4/bin \
    PASSWORD=glassfish \
    DOMAIN_ROOT=/glassfish4/glassfish/domains/domain1

# Install packages, download and extract GlassFish
# Setup password file
# Enable DAS
# Create symlinks
RUN apk add --update wget unzip && \
    wget --no-check-certificate $GLASSFISH_URL && \
    unzip -o $GLASSFISH_PKG && \
    rm -f $GLASSFISH_PKG && \
    apk del wget unzip && \
    echo "--- Setup the password file ---" && \
    echo "AS_ADMIN_PASSWORD=" > /tmp/glassfishpwd && \
    echo "AS_ADMIN_NEWPASSWORD=${PASSWORD}" >> /tmp/glassfishpwd  && \
    echo "--- Enable DAS, change admin password, and secure admin access ---" && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1 && \
    asadmin start-domain && \
    echo "AS_ADMIN_PASSWORD=${PASSWORD}" > /tmp/glassfishpwd && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd enable-secure-admin && \
    asadmin --user=admin stop-domain && \
    rm /tmp/glassfishpwd && \
    mkdir /data && \
    ln -s "${DOMAIN_ROOT}/applications" /data/applications && \
    ln -s "${DOMAIN_ROOT}/logs" /data/logs && \
    ln -s "${DOMAIN_ROOT}/docroot" /data/static

# Updated domain.xml
#  context root being /app,
#  disabling a bunch of unnecessary services,
#  removing the SSL listener
#  disabling xpoweredby and server headers
COPY ./domain.xml /glassfish4/glassfish/domains/domain1/config/domain.xml

# Ports being exposed
EXPOSE 4848 8080

# Start asadmin console and the domain
CMD ["asadmin", "start-domain", "-v"]

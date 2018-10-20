FROM library/centos:7.5.1804

MAINTAINER Valentin Delaye <jonesbusy@gmail.com>

# Force UTF-8 stuff
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8" JAVA_HOME=/usr/java/jdk-11.0.1

# Install Oracle JDK and set it as default (can be changed by applications)
RUN yum update -y && yum install -y curl unzip && curl -O --silent https://d3rh6fyf3sdelq.cloudfront.net/oracle/jdk/11.0.1/jdk-11.0.1_linux-x64_bin.rpm && \ 
    rpm -i jdk-11.0.1_linux-x64_bin.rpm 
    
# Update alternatives 
RUN update-alternatives --set java /usr/java/jdk-11.0.1/bin/java && yum clean all && rm -Rf /var/cache/yum && java -version

# Add script files
ADD ["docker-entrypoint.sh", "/"]

# Run user
RUN mkdir /opt/package && \
    adduser --system --no-create-home --shell /bin/false --gid 0 java && \ 
    chown -R java:root /opt/package && \
    chmod +x /docker-entrypoint.sh && \
    chown java:root /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

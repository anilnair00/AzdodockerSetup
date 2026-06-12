FROM ubuntu:22.04

ARG ANT_VERSION=1.10.14 

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    ANT_HOME=/opt/ant \
    PATH="${PATH}:${ANT_HOME}/bin:${JAVA_HOME}/bin"

# Install only required packages (no upgrade for reproducibility)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk \
        ca-certificates \
        curl \
        openssh-client \
        bash \
        git \
        tar \
        gzip && \
    curl -fsSL https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz -o /tmp/apache-ant.tar.gz && \    
    tar -xzf /tmp/apache-ant.tar.gz -C /opt && \
    ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant && \
    ln -s /opt/ant/bin/ant /usr/bin/ant && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -f /tmp/apache-ant.tar.gz && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Prevent SSH host verification failures in CI
RUN groupadd -g 1000 harnessgroup && \
    useradd -u 1000 -g harnessgroup -s /bin/bash -m harnessuser

RUN mkdir -p /home/harnessuser/.ssh && \
    chown -R 1000:1000 /home/harnessuser

USER 1000:1000

WORKDIR /harness

CMD ["ant", "-version"]

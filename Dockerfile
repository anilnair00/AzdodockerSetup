FROM ubuntu:22.04
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

RUN apt update && \
  apt upgrade -y && \
  apt-get install -y dotnet-sdk-8.0 && \
  apt-get install -y aspnetcore-runtime-8.0 && \
  apt-get install -y wget unzip && \
          msodbcsql18 \
        mssql-tools \
  apt install -y curl git jq libicu70

############################################################################################
# Download and install SQLPackage
RUN wget -O sqlpackage.zip https://aka.ms/sqlpackage-linux \
    && unzip sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage \
    && rm /sqlpackage.zip
RUN wget "http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl3_3.1.5-1_amd64.deb" \
    && dpkg -i libssl3_3.1.5-1_amd64.deb \
    && rm libssl3_3.1.5-1_amd64.deb
#USER mssql
ENV PATH=$PATH:/opt/mssql-tools/bin:/opt/sqlpackage
  
##################################################################################################
# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]

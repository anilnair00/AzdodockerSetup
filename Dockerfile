FROM ubuntu:22.04
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

RUN apt update && \
  apt upgrade -y && \
  apt-get install -y dotnet-sdk-8.0 && \
  apt-get install -y aspnetcore-runtime-8.0 && \
  apt-get install -y wget unzip && \
  apt install -y curl git jq libicu70


# Download and install SQLPackage
RUN wget https://download.microsoft.com/download/e/6/1/e61b0e7b-2c4d-4c4b-8e5e-1b3b9d7d5c1b/sqlpackage-linux-x64.zip && \
    unzip sqlpackage-linux-x64.zip -d /usr/local/bin && \
    rm sqlpackage-linux-x64.zip
  

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

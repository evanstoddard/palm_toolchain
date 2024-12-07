FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y gperf gcc build-essential sudo git terminfo libncurses5-dev flex bison autoconf make texinfo

# Create a non-root user
RUN useradd -ms /bin/bash dev-user

# Give the non-root user sudo privileges
RUN echo "dev-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the new user
USER dev-user

# Set the working directory
WORKDIR /home/dev-user/

# Build and install toolchain
RUN git clone https://github.com/evanstoddard/palm_gnu_tools.git
RUN sudo ./palm_gnu_tools/tools/build.sh
RUN sudo cp -r ./palm_gnu_tools/dist/opt /
RUN sudo rm -rf ./palm_gnu_tools
RUN echo 'export PATH=${PATH}:/opt/palm_gnu_tools/bin' >> ~/.bashrc
RUN sudo chmod -R a+w /opt/palm_gnu_tools

# Install Palm SDKs
RUN sudo git clone https://github.com/jichu4n/palm-os-sdk.git /opt/palmdev

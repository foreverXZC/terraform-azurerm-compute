# Pull the base image with given version.
ARG BUILD_TERRAFORM_VERSION="0.11.1"
FROM microsoft/terraform-test:${BUILD_TERRAFORM_VERSION}

ARG MODULE_NAME="terraform-azurerm-compute"

# Declare default build configurations for terraform.
ARG BUILD_ARM_SUBSCRIPTION_ID=""
ARG BUILD_ARM_CLIENT_ID=""
ARG BUILD_ARM_CLIENT_SECRET=""
ARG BUILD_ARM_TENANT_ID=""
ARG BUILD_ARM_TEST_LOCATION="WestEurope"
ARG BUILD_ARM_TEST_LOCATION_ALT="WestUS"

# Set environment variables for terraform runtime.
ENV ARM_SUBSCRIPTION_ID=${BUILD_ARM_SUBSCRIPTION_ID}
ENV ARM_CLIENT_ID=${BUILD_ARM_CLIENT_ID}
ENV ARM_CLIENT_SECRET=${BUILD_ARM_CLIENT_SECRET}
ENV ARM_TENANT_ID=${BUILD_ARM_TENANT_ID}
ENV ARM_TEST_LOCATION=${BUILD_ARM_TEST_LOCATION}
ENV ARM_TEST_LOCATION_ALT=${BUILD_ARM_TEST_LOCATION_ALT}

RUN mkdir /usr/src/${MODULE_NAME}
COPY . /usr/src/${MODULE_NAME}

RUN ssh-keygen -q -t rsa -b 4096 -f $HOME/.ssh/id_rsa

WORKDIR /usr/src/${MODULE_NAME}
RUN apt-get install software-properties-common >dev/null
RUN add-apt-repository ppa:gophers/archive >/dev/null
RUN apt-get update >/dev/null
RUN apt-get install golang-1.10-go >/dev/null
RUN apt-get install -y unzip >/dev/null
RUN wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip >/dev/null 2>&1
RUN unzip terraform_0.11.1_linux_amd64.zip >/dev/null
# RUN wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz >/dev/null 2>&1
# RUN tar -zxvf go1.9.2.linux-amd64.tar.gz -C /usr/local/ >/dev/null
RUN mv terraform /usr/local/bin

RUN go get golang.org/x/crypto/ssh
RUN go get github.com/gruntwork-io/terratest/modules/retry
RUN go get github.com/gruntwork-io/terratest/modules/ssh
RUN go get github.com/gruntwork-io/terratest/modules/terraform
RUN go get github.com/gruntwork-io/terratest/modules/test-structure

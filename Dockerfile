FROM ubuntu:16.04
MAINTAINER Xizhi Xu <xizhi.xu@outlook.com>

ENV VERSION_SDK_TOOLS "3859397"

ENV ANDROID_HOME "/android_sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools/bin"
ENV DEBIAN_FRONTEND noninteractive

# Install tools
RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      openjdk-8-jdk \
      curl \
      wget \
      unzip \
      make \
      html2text \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get clean

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip > /sdk.zip && \
    unzip /sdk.zip -d ${ANDROID_HOME} && \
    rm -v /sdk.zip

ADD packages ${ANDROID_HOME}
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update && \
  (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/bin/sdkmanager --package_file=${ANDROID_HOME}/packages
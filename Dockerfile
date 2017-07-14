FROM ubuntu:16.04
MAINTAINER Xizhi Xu <xizhi.xu@outlook.com>

ENV VERSION_SDK_TOOLS "3859397"

ENV ANDROID_HOME /android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
ENV DEBIAN_FRONTEND noninteractive

# Install tools
RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      openjdk-8-jdk \
      git-all \
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

# Android sdk tools
RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip > /sdk.zip && \
    unzip /sdk.zip -d ${ANDROID_HOME} && \
    rm -v /sdk.zip

# Agreements
RUN mkdir -p $ANDROID_HOME/licenses/ \
  && echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license \
  && echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license

# Install sdk
ADD packages ${ANDROID_HOME}
RUN mkdir -p /root/.android && \
  touch /root/.android/repositories.cfg && \
  $ANDROID_HOME/tools/bin/sdkmanager --update && \
  (while [ 1 ]; do sleep 5; echo y; done) | $ANDROID_HOME/tools/bin/sdkmanager --package_file=$ANDROID_HOME/packages

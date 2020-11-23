# ##############################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
# ##############################################################################

# Based on https://github.com/apache/flink-docker/blob/master/1.11/scala_2.12-debian/Dockerfile and modified for Raspberry Pi

# FROM balenalib/raspberry-pi-debian-openjdk:8-stretch-build as BUILD

FROM adoptopenjdk/openjdk11:debian-slim as BUILD

RUN set -ex; \
    apt-get update; \
    apt-get -y install gcc; \
    curl -o /sbin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
    gcc -Wall /sbin/su-exec.c -o/sbin/su-exec; \
    chown root:root /sbin/su-exec; \
    chmod 0755 /sbin/su-exec; \
    rm /sbin/su-exec.c

FROM adoptopenjdk/openjdk11:debian-slim

RUN set -ex; \
    apt-get update; \
    apt-get -y install libsnappy1v5 gettext-base wget; \
    rm -rf /var/lib/apt/lists/*

# Configure Flink version
ENV FLINK_TGZ_URL=https://www.apache.org/dyn/closer.cgi?action=download&filename=flink/flink-1.11.1/flink-1.11.1-bin-scala_2.12.tgz

# Prepare environment
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
RUN groupadd --system --gid=9999 flink && \
    useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=flink flink
WORKDIR $FLINK_HOME

# Install Flink
RUN set -ex; \
  wget -nv -O flink.tgz "$FLINK_TGZ_URL"; \
  tar -xf flink.tgz --strip-components=1; \
  rm flink.tgz; \
  chown -R flink:flink .;


# Copy across su-exec
COPY --from=BUILD /sbin/su-exec /sbin/ 


# Configure container
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 6123 8081
CMD ["help"]

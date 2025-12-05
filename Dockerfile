FROM veupathdb/gus-apidb-base:1.2.11

ENV LANG=en_US.UTF-8 \
    JVM_MEM_ARGS="-Xms16m -Xmx64m" \
    JVM_ARGS="" \
    TZ="America/New_York" \
    PATH=/opt/veupathdb/bin:$PATH

RUN apt-get update \
    && apt-get install -y locales \
    && sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get install -y tzdata curl wget perl unzip git \
    && apt-get clean \
    && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
    && echo ${TZ} > /etc/timezone

# ADDITIONAL PERL DEPENDENCIES
RUN perl -MCPAN -e 'install qq(Switch)' \
    && perl -MCPAN -e 'install qq(Config::Std)' \
    && perl -MCPAN -e 'install qq(Text::Unidecode)' \
    && perl -MCPAN -e 'install qq(Date::Calc)' \
    && perl -MCPAN -e 'install qq(XML::Simple)' \
    && perl -MCPAN -e 'install qq(Digest::SHA1)'

# Install find-bin-width tool.
RUN wget -q -O fbw.zip https://github.com/VEuPathDB/script-find-bin-width/releases/download/v1.0.3/fbw-linux-1.0.3.zip \
    && unzip fbw.zip \
    && rm fbw.zip \
    && mv find-bin-width /usr/bin/find-bin-width

ARG SHARED_LIB_GIT_COMMIT_SHA=bf9773e864eb09b1013c4fbc9e0f6f73d8fa2f77
RUN git clone https://github.com/VEuPathDB/vdi-lib-plugin-eda.git \
    && cd vdi-lib-plugin-eda \
    && git checkout ${SHARED_LIB_GIT_COMMIT_SHA} \
    && mkdir -p /opt/veupathdb/lib/perl /opt/veupathdb/bin \
    && cp lib/perl/VdiStudyHandlerCommon.pm /opt/veupathdb/lib/perl \
    && cp bin/* /opt/veupathdb/bin

ARG APICOMMONDATA_COMMIT_HASH=9270a2c542f374b33deedaa60e4898e9e7479cc7 \
    CLINEPIDATA_GIT_COMMIT_SHA=8d31ba1b5cf7f6b022058b7c89e8e3ab0665f543 \
    EDA_NEXTFLOW_GIT_COMMIT_SHA=f113cca94b9d16695dc4ac721de211d72e7c396f

# CLONE ADDITIONAL GIT REPOS
COPY bin/buildGus.bash /usr/bin/buildGus.bash
RUN /usr/bin/buildGus.bash

# VDI PLUGIN SERVER
ARG PLUGIN_SERVER_VERSION=v1.7.0-a20
RUN curl "https://github.com/VEuPathDB/vdi-service/releases/download/${PLUGIN_SERVER_VERSION}/plugin-server.tar.gz" -Lf --no-progress-meter | tar -xz

ENV PYTHONPATH "${PYTHONPATH}:/opt/veupathdb/lib/python"

COPY pip-requirements.txt pip-requirements.txt

RUN apt-get update \
    && apt-get install -y python3 python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -r pip-requirements.txt --break-system-packages

COPY bin /opt/veupathdb/bin
COPY lib /opt/veupathdb/lib
RUN chmod +x /opt/veupathdb/bin/*

CMD PLUGIN_ID=biom run-plugin.sh

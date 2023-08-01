FROM veupathdb/vdi-plugin-base:1.0.3

RUN apt-get update && apt-get install -y \
    python3-pip

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir biom-format && \
    pip3 install --no-cache-dir future

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib
# COPY testdata/ /opt/veupathdb/testdata

RUN chmod +x /opt/veupathdb/bin/*

RUN export LIB_GIT_COMMIT_SHA=4fcd4f3183f8decafe7a0d0a8a8400470c7f9222\
    && git clone https://github.com/VEuPathDB/lib-vdi-plugin-study.git \
    && cd lib-vdi-plugin-study \
    && git checkout $LIB_GIT_COMMIT_SHA \
    && mkdir -p /opt/veupathdb/lib/perl \
    && cp lib/perl/VdiStudyHandlerCommon.pm /opt/veupathdb/lib/perl \
    && cp bin/* /opt/veupathdb/bin

ENV PYTHONPATH "${PYTHONPATH}:/opt/veupathdb/lib/python"

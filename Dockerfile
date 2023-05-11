FROM veupathdb/vdi-plugin-base:latest

RUN apk add --no-cache bash; \
  mkdir "/opt/veupathdb"

COPY bin/ /opt/veupathdb/bin

RUN chmod +x /opt/veupathdb/bin/*

RUN export LIB_GIT_COMMIT_SHA=4fcd4f3183f8decafe7a0d0a8a8400470c7f9222\
    && git clone https://github.com/VEuPathDB/lib-vdi-handler-study.git \
    && cd lib-vdi-handler-study \
    && git checkout $LIB_GIT_COMMIT_SHA \
    && mkdir -p /opt/veupathdb/lib/perl \
    && cp lib/perl/VdiStudyHandlerCommon.pm /opt/veupathdb/lib/perl \
    && cp bin/* /opt/veupathdb/bin
    

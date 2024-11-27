FROM veupathdb/vdi-plugin-isasimple:1.4.0

ENV PYTHONPATH "${PYTHONPATH}:/opt/veupathdb/lib/python"

COPY pip-requirements.txt pip-requirements.txt

RUN apt-get update \
    && apt-get install -y python3 python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade pip --break-system-packages \
    && pip3 install -r pip-requirements.txt --break-system-packages

COPY bin /opt/veupathdb/bin
COPY lib /opt/veupathdb/lib

#FROM veupathdb/vdi-plugin-base:3.0.0
FROM jbrestel/vdi-plugin-isasimple:latest

RUN apt-get update && \
    apt-get install -y python3 python3-pip &&  \
    rm -rf /var/lib/apt/lists/*


WORKDIR /opt/veupathdb/.local


COPY bin/ /usr/bin
COPY lib/ /opt/veupathdb/.local/lib


ENV PYTHONPATH "${PYTHONPATH}:/opt/veupathdb/.local/lib/python"

#NOTE: Tried venv like "python3 -m venv /opt/veupathdb/.local"
#    this failed because ensurepip package missing from ubuntu
#    would be better to make virtual env here and remove "break-system-packages"
RUN pip3 install --upgrade pip --break-system-packages
RUN pip3 install numpy --break-system-packages
RUN pip3 install biom-format  --break-system-packages
RUN pip3 install h5py  --break-system-packages
RUN pip3 install future --break-system-packages

FROM jupyter/r-notebook:83a5335f7132

USER root
RUN apt-get update && apt-get install -y --no-install-recommends mono-runtime
RUN wget https://github.com/smith-chem-wisc/FlashLFQ/releases/download/1.2.3/FlashLFQ.zip && unzip FlashLFQ.zip -d FLashLFQ

USER ${NB_UID}

COPY . .

RUN if [ -f install.R ]; then R --quiet -f install.R; fi

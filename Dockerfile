FROM jupyter/r-notebook:83a5335f7132

RUN apt-get update && apt-get install -y --no-install-recommends mono
RUN wget https://github.com/smith-chem-wisc/FlashLFQ/releases/download/1.2.3/FlashLFQ.zip && unzip FlashLFQ.zip -d FLashLFQ

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

COPY . .

RUN if [ -f install.R ]; then R --quiet -f install.R; fi

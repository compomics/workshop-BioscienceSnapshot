FROM jupyter/r-notebook:83a5335f7132

USER root
RUN wget -O '/tmp/rstudio.deb' https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.07.1-554-amd64.deb && \
    apt-get update && \
    apt-get -y --no-install-recommends install /tmp/rstudio.deb && \
    echo "rsession-which-r=${CONDA_DIR}/bin/R" >> /etc/rstudio/rserver.conf && \
    echo "rsession-ld-library-path=${CONDA_DIR}/lib" >> /etc/rstudio/rserver.conf

USER ${NB_UID}

RUN mamba install --quiet --yes 'r-ggplot2' \
    'jupyter-rsession-proxy' \
    'dotnet-sdk' && \
    mamba install --quiet --yes -c bioconda 'flashlfq' \
    'bioconductor-genomeinfodbdata==1.2.6' \
    'bioconductor-qfeatures' \
    'bioconductor-msqrob2' \
    'bioconductor-limma' \
    'bioconductor-exploremodelmatrix' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

ENV PATH="${CONDA_DIR}/lib/dotnet:${CONDA_DIR}/lib/dotnet/tools:${PATH}"
ENV CONDA_PREFIX="${CONDA_DIR}"

RUN echo "CONDA_PREFIX=$CONDA_PREFIX'" >> /etc/R/Renviron.site

COPY . .

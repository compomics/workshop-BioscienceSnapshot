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
    'bioconductor-exploremodelmatrix' \
    'bioconductor-msnbase' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

ENV PATH="${CONDA_DIR}/lib/dotnet:${CONDA_DIR}/lib/dotnet/tools:${PATH}"
ENV CONDA_PREFIX="${CONDA_DIR}"

RUN echo "CONDA_PREFIX='${CONDA_DIR}'" >> "${HOME}/.Renviron"

# NOTE: this assumes default user. Sadly, we can't use variables for this, although it would be possible to change the user to root and do a chown
COPY --chown=jovyan:jovyan . .

RUN wget -P Data_part2 http://genesis.ugent.be/uvpublicdata/workshop-bioscience-snapshot/id_files/flashlfq_input.tsv && \
    wget -P Data_part2/RAW https://genesis.ugent.be/uvpublicdata/workshop-bioscience-snapshot/RAW/20160531_QE5_nLC14_RJC_COLLAB_GeoG_988_01.raw https://genesis.ugent.be/uvpublicdata/workshop-bioscience-snapshot/RAW/20160531_QE5_nLC14_RJC_COLLAB_GeoG_1002_01.raw

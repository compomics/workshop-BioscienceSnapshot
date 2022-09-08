FROM jupyter/r-notebook:83a5335f7132

RUN mamba install --quiet --yes 'r-ggplot2' \
    'dotnet-sdk' && \
    mamba install -c bioconda 'flashlfq' \
    'bioconductor-genomeinfodbdata==1.2.6' \
    'bioconductor-qfeatures' \
    'bioconductor-msqrob2' \
    'bioconductor-limma' \
    'bioconductor-exploremodelmatrix' && \
    mamba install -c r 'rstudio' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY . .

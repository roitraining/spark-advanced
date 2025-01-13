# Base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone to America/New_York
RUN apt-get update && \
    apt-get install -y tzdata wget npm && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda and add it to PATH
RUN cd /tmp && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -f -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    /opt/conda/bin/conda config --system --prepend channels conda-forge && \
    /opt/conda/bin/conda config --system --set auto_update_conda false && \
    /opt/conda/bin/conda config --system --set show_channel_urls true && \
    /opt/conda/bin/conda update -n base -c defaults conda --quiet --yes && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> /opt/conda/conda-meta/pinned && \
    conda clean --all -f -y && \
    rm -rf /root/.cache/yarn

# Add Conda to PATH for future RUN commands
ENV PATH="/opt/conda/bin:$PATH"

# Ensure fix-permissions is available
RUN wget -O /usr/local/bin/fix-permissions https://raw.githubusercontent.com/jupyter/docker-stacks/main/base-notebook/fix-permissions && \
    chmod +x /usr/local/bin/fix-permissions

# Apply permissions
RUN fix-permissions /opt/conda && \
    fix-permissions /root

# Install Tini
RUN conda install --quiet --yes 'tini=0.19.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> /opt/conda/conda-meta/pinned && \
    conda clean --all -f -y && \
    fix-permissions /opt/conda && \
    fix-permissions /root

# Install Jupyter Notebook, Lab, and Hub
RUN conda install --quiet --yes \
    'notebook=7.0.0' \
    'jupyterhub=4.0.0' \
    'jupyterlab=4.0.5' && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    rm -rf /opt/conda/share/jupyter/lab/staging && \
    rm -rf /root/.cache/yarn && \
    fix-permissions /opt/conda && \
    fix-permissions /root

EXPOSE 8888

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/

# Set executable permissions on scripts
RUN chmod +x /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/start-notebook.sh && \
    chmod +x /usr/local/bin/start-singleuser.sh

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

# ===============================================================================
#                        BASE IMAGE AND GENERAL SETUP
# ===============================================================================

# Define base image
FROM fedora:latest

# Define labels
LABEL version="0.1" \
    maintainer="Michele Peresano" \
    description="Docker image to create containers for using protopipe on DIRAC"

# Install basic packages
RUN yum update -y && yum install -y wget git vim tree gcc gcc-c++
# gcc g++ are required to install gammapy and eventio for ctapipe 0.11

# Add non-root user and work from his home directory
ARG USERNAME=cta
ENV HOME /home/cta
RUN useradd -rm -d $HOME -s /bin/bash -u 1000 ${USERNAME}
USER ${USERNAME}
WORKDIR $HOME

# Override default shell and use bash
SHELL ["/bin/bash", "--login", "-c"]

# ===============================================================================
#                                 MINICONDA
# ===============================================================================

# Get Miniconda
# install in batch (silent) mode, does not edit PATH or .bashrc or .bash_profile
# -p path
# -f force
# RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#     && bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda \
#     && rm Miniconda3-latest-Linux-x86_64.sh
# ENV PATH=$HOME/miniconda/bin:${PATH}

# make conda activate command available from /bin/bash --login shells 
# Install mamba and update base environment
# RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.profile \
#     && conda init bash && \
#     conda update -y conda && \
#     conda install mamba -n base -c conda-forge \
#     && mamba update --all

# ===============================================================================
#                          PROTOPIPE GRID INTERFACE
# ===============================================================================

# Get latest environment file and create environment
# WARNING: in the final Dockerfile the pull must come from either the
# master branch (development version) or from a tagged release (released version)
WORKDIR /home/cta/test_Docker_deployment
RUN git clone https://github.com/HealthyPear/test_Docker_deployment.git .\
    && git fetch --tags \
    && latestTag=$(git describe --tags `git rev-list --tags --max-count=1`) \
    && git checkout $latestTag \
    # && mamba env create -f environment_release.yaml \
    # && conda activate protopipe-CTADIRAC \
    # && pip install '.[all]' \
    # && echo "conda activate protopipe-CTADIRAC" >> ~/.bashrc \
    # && echo "alias ls='ls --color'" >> ~/.bashrc
    && touch test.txt

WORKDIR /home/cta/
ENTRYPOINT ["bash"]
FROM ubuntu:focal

LABEL author="Sohum Mendon"
LABEL maintainer="sohum.mendon@gmail.com"
LABEL description="This Dockerizes the TeX Live distribution of LaTeX."
LABEL version="1.0"

ARG DEBIAN_FRONTEND=noninteractive
ARG scheme=scheme-basic
ARG USERNAME=tex
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update -qy && apt-get install -qy \
    git \
    perl \
    sudo \
    wget \
&& rm -rf /var/lib/apt/lists/*

# do git management now ?

# Download TeX Live, install the chosen scheme, delete install files, and add non-root user
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
        && mkdir /install-tl \
        && tar -xvf install-tl-unx.tar.gz -C /install-tl --strip-components=1 \
    && echo "selected_scheme ${scheme}" >> /install-tl/profile \
        && /install-tl/install-tl -profile /install-tl/profile \
    && rm -r /install-tl \
        && rm install-tl-unx.tar.gz

# Change the path.
ENV PATH=/usr/local/texlive/2020/bin/x86_64-linux:${PATH}
ENV MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:${MANPATH}
ENV INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:${INFOPATH}

# Ensure certain packages are installed
RUN tlmgr install \
    chktex \
    latexindent \
    latexmk

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # Add sudo support.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME

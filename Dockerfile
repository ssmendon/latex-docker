FROM alpine:latest

LABEL author="Sohum Mendon"
LABEL maintainer="sohum.mendon@gmail.com"
LABEL description="This Dockerizes the TeX Live distribution of LaTeX."
LABEL version="1.0"

ARG DEBIAN_FRONTEND=noninteractive
ARG scheme=scheme-basic
ARG USERNAME=tex
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apk add --no-cache \
    perl \
    wget

# Download TeX Live, install the chosen scheme, delete install files, and add non-root user
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
        mkdir /install-tl && \
        tar -xvf install-tl-unx.tar.gz -C /install-tl --strip-components=1 && \
    #
    # Installing scheme
    echo "selected_scheme ${scheme}" >> /install-tl/profile && \
        /install-tl/install-tl -profile /install-tl/profile && \
    #
    # Clean up
    rm -r /install-tl && \
        rm install-tl-unx.tar.gz

# Change the path.
ENV PATH=/usr/local/texlive/2020/bin/x86_64-linuxmusl:${PATH}
ENV MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:${MANPATH}
ENV INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:${INFOPATH}

# Ensure certain packages are installed
RUN tlmgr install \
    chktex \
    latexindent \
    latexmk

# Create the user
RUN addgroup --gid $USER_GID $USERNAME && \
    adduser --uid $USER_UID \
        --ingroup $USERNAME \
        --gecos "" \
        --disabled-password \
        $USERNAME

# Set the default user
USER $USERNAME

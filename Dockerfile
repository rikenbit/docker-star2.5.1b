# According to genomicpariscentre/star,  
# I wrote Dockerfile to build STAR_2.5.1b

# Set the base image to Ubuntu
FROM ubuntu:14.04 AS build-env

# File Author / Maintainer
LABEL maintainer="Hiroki Danno <redgrapefruit@mac.com>"

# Update the repository sources list
RUN apt-get update && \
: `# Install compiler` && \
    apt-get install --yes \
        build-essential \
        gcc-multilib \
        apt-utils \
        zlib1g-dev \
        g++ \
        make \
        vim-common \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
: `# Install STAR` && \
    cd /usr/local && \
    pwd && \
    git clone https://github.com/alexdobin/STAR.git && \
    cd /usr/local/STAR && \
    pwd && \
    git checkout 2.5.1b && \
    cd /usr/local/STAR/source && \ 
    pwd && \
    make STAR

FROM ubuntu:14.04
LABEL maintainer="Hiroki Danno <redgrapefruit@mac.com>" \
      description="A containerized STAR" \
      license="https://github.com/alexdobin/STAR/blob/2.5.1b/LICENSE"
RUN apt-get update && \
    apt-get install --yes libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ 
COPY --from=build-env /usr/local/STAR/source/STAR /usr/local/bin

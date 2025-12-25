FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Eastern

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install sudo curl git jq apache2 wget apt-utils -y


ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 24.12.0

# Install nvm with node and npm
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN . $NVM_DIR/nvm.sh
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN ls $NVM_DIR/versions/node

# RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

RUN git clone https://github.com/nerosketch/quakejs.git --recurse-submodules
WORKDIR /quakejs

# not available anymore
RUN npm uninstall quakejs-files

RUN npm install
RUN ls
COPY server.cfg /quakejs/base/baseq3/server.cfg
COPY server.cfg /quakejs/base/cpma/server.cfg
# The two following lines are not necessary because we copy assets from include.  Leaving them here for continuity.
# WORKDIR /var/www/html
# RUN bash /var/www/html/get_assets.sh
COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js

RUN rm /var/www/html/index.html && cp /quakejs/html/* /var/www/html/
COPY ./include/assets/ /var/www/html/assets
RUN ls /var/www/html

WORKDIR /
ADD entrypoint.sh /entrypoint.sh
# Was having issues with Linux and Windows compatibility with chmod -x, but this seems to work in both
RUN chmod 777 ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

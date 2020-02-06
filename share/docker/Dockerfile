FROM ghost:3.5.0-alpine

LABEL maintainer="hugo@exec.sh"

# Set app runtime environment variables
ARG NPM_TOKEN
ARG NAME
ENV NAME $NAME
ARG VERSION
ENV VERSION $VERSION
ARG VERSION_COMMIT
ENV VERSION_COMMIT $VERSION_COMMIT
ARG VERSION_BUILD_DATE
ENV VERSION_BUILD_DATE $VERSION_BUILD_DATE

# Create app directory
RUN set -eux; \
  mkdir /home/node/$NAME; \
  chown node:node /home/node/$NAME
WORKDIR /home/node/$NAME

# Install utils
RUN set -x \
  && apk --no-cache add \
    su-exec \
    curl \
    netcat-openbsd

# Copy app source
COPY --chown=node:node package.json package.json
COPY --chown=node:node package-lock.json package-lock.json
COPY --chown=node:node .snyk .snyk
COPY --chown=node:node src src/
COPY --chown=node:node share/docker/start.sh start.sh
COPY --chown=node:node share/docker/test.sh test.sh

# Patch ghost installation
COPY --chown=node:node share/ghost/icon.png $GHOST_INSTALL/content.orig/images/2019/01/icon.png
COPY --chown=node:node share/ghost/logo.png $GHOST_INSTALL/content.orig/images/2019/01/logo.png
COPY --chown=node:node share/ghost/config.production.json $GHOST_INSTALL/config.production.json
COPY --chown=node:node share/ghost/default-settings.json $GHOST_INSTALL/current/core/server/data/schema/default-settings.json
COPY --chown=node:node share/ghost/ghost.patch $GHOST_INSTALL/ghost.patch
RUN set -x \
  && cd $GHOST_INSTALL && su-exec node patch -p1 < ghost.patch && rm ghost.patch \
  && su-exec node ln -s /home/node/$NAME/src $GHOST_INSTALL/current/content/themes/$NAME \
  && su-exec node ln -s $GHOST_INSTALL/current/content/themes/$NAME $GHOST_INSTALL/content.orig/themes/$NAME \
  && cd $GHOST_INSTALL/current && su-exec node yarn add modern-logger@1.5.53 \
  && su-exec node yarn cache clean && su-exec node npm cache clean --force && npm cache clean --force && rm -rv /tmp/yarn* /tmp/v8*

EXPOSE 3000

ENTRYPOINT [ "./start.sh" ]

HEALTHCHECK --start-period=10s --interval=5m --timeout=3s \
  CMD nc -z localhost 3000 || exit 1

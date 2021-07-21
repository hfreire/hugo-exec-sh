FROM ghost:4.10.0-alpine AS ghost

# Install utils
RUN set -x \
  && apk --no-cache add \
    su-exec \
    curl \
    netcat-openbsd

# Patch ghost code
COPY --chown=node:node share/ghost/ghost.patch $GHOST_INSTALL/ghost.patch
RUN set -x \
  && cd $GHOST_INSTALL \
    && su-exec node patch -p1 < ghost.patch \
    && rm ghost.patch \
  && cd $GHOST_INSTALL/current \
    && su-exec node yarn add modern-logger@1.5.53 \
    && su-exec node yarn cache clean \
    && su-exec node npm cache clean --force \
    && npm cache clean --force \
    && rm -rv /tmp/yarn* /tmp/v8*

# Replace default ghost assets and configuration
COPY --chown=node:node share/ghost/icon.png $GHOST_INSTALL/content.orig/images/2019/01/icon.png
COPY --chown=node:node share/ghost/logo.png $GHOST_INSTALL/content.orig/images/2019/01/logo.png
COPY --chown=node:node share/ghost/config.production.json $GHOST_INSTALL/config.production.json
COPY --chown=node:node share/ghost/default-settings.json $GHOST_INSTALL/current/core/server/data/schema/default-settings.json

FROM ghost AS build
ARG NAME
ARG NPM_TOKEN
USER node

RUN mkdir /home/node/$NAME
WORKDIR /home/node/$NAME

# Install npm packages
COPY --chown=node:node package.json package-lock.json .snyk ./
RUN NODE_ENV= npm ci

# Build app
COPY --chown=node:node src src/
RUN set -x \
  && npm run build --if-present \
  && npm prune --production \
  && npm cache clean --force

FROM ghost
LABEL maintainer="hugo@exec.sh"
ARG NAME
ARG VERSION
ARG VERSION_COMMIT
ARG VERSION_BUILD_DATE

RUN su-exec node mkdir /home/node/$NAME
WORKDIR /home/node/$NAME

# Copy app build
COPY --from=build --chown=node:node /home/node/$NAME /home/node/$NAME
COPY --chown=node:node share/docker/start.sh start.sh
COPY --chown=node:node share/docker/test.sh test.sh

# Link app with ghost installation
RUN set -x \
  && su-exec node ln -s /home/node/$NAME/src $GHOST_INSTALL/current/content/themes/$NAME \
  && su-exec node ln -s $GHOST_INSTALL/current/content/themes/$NAME $GHOST_INSTALL/content.orig/themes/$NAME

# Set app runtime environment variables
ENV NAME $NAME
ENV VERSION $VERSION
ENV VERSION_COMMIT $VERSION_COMMIT
ENV VERSION_BUILD_DATE $VERSION_BUILD_DATE

EXPOSE 3000

ENTRYPOINT [ "./start.sh" ]

HEALTHCHECK --start-period=10s --interval=5m --timeout=3s \
  CMD nc -z localhost 3000 || exit 1

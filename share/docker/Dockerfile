FROM ghost:2.19.1-alpine

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

# Install utils
RUN apk --no-cache add \
    su-exec \
    curl \
    netcat-openbsd

# Copy app source
COPY --chown=node:node package.json current/content/themes/$NAME/package.json
COPY --chown=node:node src current/content/themes/$NAME/
COPY --chown=node:node share/ghost/config.production.json config.production.json
COPY --chown=node:node share/ghost/default-settings.json current/core/server/data/schema/default-settings.json
COPY --chown=node:node share/ghost/ghost.patch ghost.patch
COPY --chown=node:node share/docker/start.sh start.sh
COPY --chown=node:node share/docker/test.sh test.sh

RUN su-exec node ln -s $GHOST_INSTALL/current/content/themes/$NAME content.orig/themes/$NAME && \
    patch -p1 < ghost.patch && rm ghost.patch

EXPOSE 3000

ENTRYPOINT [ "./start.sh" ]

HEALTHCHECK --start-period=10s --interval=5m --timeout=3s \
  CMD nc -z localhost 3000 || exit 1

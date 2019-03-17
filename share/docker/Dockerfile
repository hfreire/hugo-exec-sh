FROM ghost:1.25.6-alpine

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
COPY --chown=node:node src $GHOST_INSTALL/content.orig/themes/$NAME/
COPY --chown=node:node share/ghost/icon.png $GHOST_INSTALL/content.orig/images/2019/01/icon.png
COPY --chown=node:node share/ghost/logo.png $GHOST_INSTALL/content.orig/images/2019/01/logo.png
COPY --chown=node:node share/ghost/default-settings.json $GHOST_INSTALL/current/core/server/data/schema/default-settings.json
COPY --chown=node:node share/docker/start.sh start.sh
COPY --chown=node:node share/docker/test.sh test.sh

RUN cd "$GHOST_INSTALL"; \
    su-exec node ghost config --ip 0.0.0.0 --port 3000

EXPOSE 3000

ENTRYPOINT [ "./start.sh" ]

HEALTHCHECK --start-period=10s --interval=5m --timeout=3s \
  CMD nc -z localhost 3000 || exit 1

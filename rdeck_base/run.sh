#!/usr/bin/dumb-init /bin/sh
set -e

JVM_ARGS=" \
  ${RDECK_JVM} \
  -Dserver.http.port=${RDECK_HTTP_PORT} \
  -Dserver.https.port=${RDECK_HTTPS_PORT} \
  -Xms${RDECK_INITIAL_HEAP:-256m} \
  -Xmx${RDECK_MAX_HEAP:-1024m} \
  -server \
"

find $RDECK_BASE -not -name 'rundeck-launcher.jar' -print0 | xargs -0 chown rundeck:

if [ "${CTMPL_EXEC:-false}" = true ]; then
  exec consul-template \
    -exec="su-exec rundeck java ${JVM_ARGS} -jar rundeck-launcher.jar --skipinstall" \
    -log-level=${CTMPL_LOG_LEVEL:-warn} \
    -config=/etc/consul-template/conf.d
else
  consul-template \
    -once \
    -log-level=${CTMPL_LOG_LEVEL:-warn} \
    -config=/etc/consul-template/conf.d
  exec su-exec rundeck java ${JVM_ARGS} -jar rundeck-launcher.jar --skipinstall
fi

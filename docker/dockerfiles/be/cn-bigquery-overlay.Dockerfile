# Overlay on the official CN image: swap in the rebuilt jdbc-bridge jar
# (BigQuery JDBC support, PR #73834 backport) and bake in the BigQuery driver.
# The BE C++ binary is unchanged by the PR, so no BE rebuild is needed.
#
# Build from the git repo root directory:
#   docker build --platform linux/amd64 \
#     -f docker/dockerfiles/be/cn-bigquery-overlay.Dockerfile \
#     -t <registry>/starrocks-cn:4.1.1-jdbc-gbq-hungnp .
ARG BASE=starrocks/cn-ubuntu:4.1.1
FROM ${BASE}
ARG STARROCKS_ROOT=/opt/starrocks

COPY --chown=starrocks:starrocks \
    docker/drivers/starrocks-jdbc-bridge-jar-with-dependencies.jar \
    $STARROCKS_ROOT/be/lib/jni-packages/starrocks-jdbc-bridge-jar-with-dependencies.jar

# Bake in the shaded BigQuery JDBC driver so catalogs can use driver_url=file://...
COPY --chown=starrocks:starrocks \
    docker/drivers/bigquery-jdbc-shaded-1.7.0.jar \
    $STARROCKS_ROOT/jdbc-drivers/bigquery-jdbc-shaded-1.7.0.jar

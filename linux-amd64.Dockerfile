FROM cr.hotio.dev/hotio/base@sha256:51b4032b5584538d5987a759e74201ef2626502750efe77d4f7124eb56284c4e

EXPOSE 6789

RUN apk add --no-cache python3 py3-lxml

# install app
ARG VERSION
ARG VERSION_SHORT
RUN runfile="/tmp/app.run" && curl -fsSL -o "${runfile}" "https://github.com/nzbget/nzbget/releases/download/v${VERSION_SHORT}/nzbget-${VERSION}-bin-linux.run" && sh "${runfile}" --destdir "${APP_DIR}" && rm "${runfile}" && \
    curl -fsSL "https://curl.se/ca/cacert.pem" | sed '/^DST Root CA X3$/,/^-----END CERTIFICATE-----$/d;' > "${APP_DIR}/cacert.pem" && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    chown -R root:root "${APP_DIR}"

COPY root/ /
RUN chmod 755 "${APP_DIR}/scripts/"*

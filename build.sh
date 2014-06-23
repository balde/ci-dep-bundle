#!/bin/bash

set -ex

source settings.sh

GLIB_VERSIONS=( 2.34.3 2.38.2 2.40.0 2.41.0 )
JSON_GLIB_VERSIONS=( 0.16.2 0.99.2 1.0.2 )
BLACKLIST=( 2.34.3/0.99.2 2.34.3/1.0.2 )


rm -rf "${DESTDIR}" "${GLIB_BUILD}" "${JSON_GLIB_BUILD}"
mkdir -p "${DESTDIR}" "${GLIB_BUILD}" "${JSON_GLIB_BUILD}"

for glib_release in ${GLIB_VERSIONS[@]}; do
    /bin/bash build-glib.sh "${glib_release}"
    for json_glib_release in ${JSON_GLIB_VERSIONS[@]}; do
        err=0
        for blacklisted in ${BLACKLIST[@]}; do
            if [[ "${glib_release}/${json_glib_release}" = "${blacklisted}" ]]; then
                err=1
                break
            fi
        done
        [[ ${err} = 1 ]] && continue
        /bin/bash build-json-glib.sh "${glib_release}" "${json_glib_release}"
    done
done

fpm \
    -t deb \
    -s dir \
    -C "${DESTDIR}" \
    --name "balde-ci-dep-bundle" \
    --version "${BUNDLE_VERSION}" \
    --license "LGPL-2.1" \
    --depends "libc6" \
    --depends "libffi6" \
    --depends "zlib1g" \
    --depends "shared-mime-info" \
    --maintainer "Rafael G. Martins <rafael@rafaelmartins.eng.br>" \
    --url "https://github.com/balde/ci-dep-bundle" \
    --description "Bundle with balde dependencies for CI." \
    .

echo Done.

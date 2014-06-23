ci-dep-bundle
=============

Scripts to generate debian/ubuntu packages to install balde deps for continuous integration purposes.


How to build the package
------------------------

- Bump ``BUNDLE_VERSION`` in ``settings.sh``
- Run ``./build.sh``


The script depends on [fpm](https://github.com/jordansissel/fpm/wiki).

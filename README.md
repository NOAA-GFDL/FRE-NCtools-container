# FRE-NCtools-container

Spack config and generated Dockerfile for container used for the CI testing of the
[FRE-NCtools repository](github.com/NOAA-GFDL/FRE-NCtools). Container is based
on Rocky Linux 9 and includes all the required libraries for building and running
the FRE-NCtools test suite.

The Dockerfile is meant to be auto-generated with `spack containerize` via the provided
yaml and template files. Instructions to do so are provided in `spack.yaml`.

Any modifications should be made to these files, `spack.yaml` and `template/Dockerfile.template`
instead of the resulting Dockerfile (which should then be generated and added accordingly).

# Support

At this time, the container(s) in this repository are used for internal testing
of [NOAA-GFDL/FRE-NCtools](https://github.com/NOAA-GFDL/FRE-NCtools).  Use of the
containers outside this purpose is not recommended.  Any support requested will
be dealt on a best-efforts basis.

# Disclaimer

The United States Department of Commerce (DOC) GitHub project code is provided
on an 'as is' basis and the user assumes responsibility for its use. DOC has
relinquished control of the information and no longer has responsibility to
protect the integrity, confidentiality, or availability of the information. Any
claims against the Department of Commerce stemming from the use of its GitHub
project will be governed by all applicable Federal law. Any reference to
specific commercial products, processes, or services by service mark,
trademark, manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce. The
Department of Commerce seal and logo, or the seal and logo of a DOC bureau,
shall not be used in any manner to imply endorsement of any commercial product
or activity by DOC or the United States Government.

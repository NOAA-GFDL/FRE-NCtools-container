#***********************************************************************
#                   GNU Lesser General Public License
#
# This file is part of the GFDL FRE NetCDF tools package (FRE-NCTools).
#
# FRE-NCTools is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# FRE-NCTools is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with FRE-NCTools.  If not, see
# <http://www.gnu.org/licenses/>.
#***********************************************************************
# Build stage with Spack pre-installed and ready to be used
FROM spack/rockylinux9:latest as builder


# What we want to install and how we want to install it
# is specified in a manifest file (spack.yaml)
RUN mkdir /opt/spack-environment \
&&  (echo spack: \
&&   echo '  specs:' \
&&   echo '  - gcc' \
&&   echo '  - mpich' \
&&   echo '  - netcdf-c' \
&&   echo '  - netcdf-fortran' \
&&   echo '  - nccmp' \
&&   echo '  concretizer:' \
&&   echo '    unify: true' \
&&   echo '  packages:' \
&&   echo '    all:' \
&&   echo '      compiler: [gcc]' \
&&   echo '  config:' \
&&   echo '    template_dirs:' \
&&   echo '    - /home/rem/fre-nctools-container/template' \
&&   echo '  # container specific options' \
&&   echo '    install_tree: /opt/software' \
&&   echo '  view: /opt/views/view') > /opt/spack-environment/spack.yaml

# Install the software, remove unnecessary deps
RUN cd /opt/spack-environment && spack env activate . && spack install --fail-fast && spack gc -y

# Modifications to the environment that are necessary to run
RUN cd /opt/spack-environment && \
    spack env activate --sh -d . > activate.sh



# Bare OS image to run the installed executables
FROM docker.io/rockylinux:9

COPY --from=builder /opt/spack-environment /opt/spack-environment
COPY --from=builder /opt/software /opt/software

# paths.view is a symlink, so copy the parent to avoid dereferencing and duplicating it
COPY --from=builder /opt/views /opt/views

RUN { \
      echo '#!/bin/sh' \
      && echo '.' /opt/spack-environment/activate.sh \
      && echo 'exec "$@"'; \
    } > /entrypoint.sh \
&& chmod a+x /entrypoint.sh \
&& ln -s /opt/views/view /opt/view


RUN dnf update -y && dnf install -y epel-release && dnf update -y \
 && dnf install -y autoconf libtool make bats git libgomp python3 python3-numpy python3-pip python3-pytest \
 && rm -rf /var/cache/dnf && dnf clean all

# Install any needed pip packages
RUN pip install git+https://github.com/adcroft/numpypi.git && \
    pip install netCDF4 virtualenv
# Set compilers for mpich wrappers
ENV MPICH_FC=gfortran
ENV MPICH_CC=gcc
LABEL "maintainer"="Seth Underwood <Seth.Underwood@noaa.gov>"
LABEL "copyright"="2021, 2022, 2023 GFDL"
LABEL "license"="LGPL v3+"
LABEL "gov.noaa.gfdl.version"="5.0.0"
LABEL "vendor"="Geophysical Fluid Dynamics Laboratory"
LABEL "gov.noaa.gfdl.release-date"="2024-01-10"
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]


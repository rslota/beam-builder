FROM circleci/python:stretch

USER root

ARG ERLANG_VERSION=22.0
ARG ELIXIR_VERSION=1.9

ENV ERLANG_VERSION ${ERLANG_VERSION}
ENV ELIXIR_VERSION ${ELIXIR_VERSION}

SHELL ["/bin/bash", "-c"]

# Handle locales
RUN apt-get update && \
        apt-get install --yes locales && \
        sed -i '/^#.* en_US.UTF-8 /s/^#//' /etc/locale.gen && \
        locale-gen

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# Install build utils
RUN apt-get install --yes \
        wget \
        unzip \
        build-essential \
        apt-transport-https \
        git

# Install Erlang & Elixir
RUN echo "deb https://packages.erlang-solutions.com/debian stretch contrib" >> /etc/apt/sources.list && \
        cat /etc/apt/sources.list && \
        wget --quiet -O - https://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
        apt-get update && \
        export EXACT_ERLANG_VERSION=`apt-cache madison esl-erlang | awk '{print \$3;}' | grep ${ERLANG_VERSION} | head -1` && \
        export EXACT_ELIXIR_VERSION=`apt-cache madison elixir | awk '{print \$3;}' | grep ${ELIXIR_VERSION} | head -1` && \
        apt-get install --yes \
        esl-erlang=$EXACT_ERLANG_VERSION \
        elixir=$EXACT_ELIXIR_VERSION

USER circleci
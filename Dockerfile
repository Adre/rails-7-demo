ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}

ARG RUBY_VERSION
ARG RAILS_VERSION
ARG BUNDLER_VERSION

RUN apt update -qq \
  && DEBIAN_FRONTEND=noninteractive apt install -yq --no-install-recommends \
    git-core \
    curl \
    zlib1g-dev \
    build-essential \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    software-properties-common \
    libffi-dev \
    gnupg2 \
    libvips \
    libvips-dev \
  && apt clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
  && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install Ruby
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc \
  && export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:/root/.rbenv/plugins/ruby-build/bin:$PATH
RUN rbenv install ${RUBY_VERSION}
RUN rbenv global ${RUBY_VERSION}

# Install bundler
ENV LANG=C.UTF-8 BUNDLE_JOBS=4 BUNDLE_RETRY=3 BUNDLE_PATH=/usr/local/bundle
RUN eval "$(rbenv init -)" \
  && echo "gem: --no-document" > ~/.gemrc \
  && gem update --system \
  && gem install bundler:${BUNDLER_VERSION} \
  && gem install rails -v ${RAILS_VERSION} \
  && rbenv rehash

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

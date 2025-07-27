# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t recipin .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name recipin recipin

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 python3 python3-pip libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN pip3 install --no-cache-dir ingredient-parser-nlp --break-system-packages && \
    pip3 install --no-cache-dir nltk --break-system-packages

# -----------------------------------------------------------------------------
# Pre-bake the required NLTK corpus so the runtime container never goes online
# to fetch it. We intentionally place the data inside `/usr/share/nltk_data`, a
# location that is already on NLTK’s default search path and readable by any
# user. Setting `ENV NLTK_DATA` means both the build-time `nltk.download()` call
# and the application at runtime look in the same place.
# -----------------------------------------------------------------------------

# Where NLTK should look for corpora
ENV NLTK_DATA=/usr/share/nltk_data

# Download the averaged_perceptron_tagger_eng corpus at image build time.
# - Creates the directory.
# - Uses Python to download directly into $NLTK_DATA.
# - Ensures rails (UID 1000) can read the files by giving world-read perms.
RUN set -eux; \
    mkdir -p "$NLTK_DATA"; \
    python3 - <<'PY'
import os, nltk
nltk.download('averaged_perceptron_tagger_eng', download_dir=os.environ['NLTK_DATA'])
PY
    ; \
    chmod -R a+rX "$NLTK_DATA"

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /home/rails/nltk_data && \
    chown -R rails:rails db log storage tmp /home/rails/nltk_data
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]

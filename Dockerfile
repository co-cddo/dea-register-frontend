# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs \
    npm \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

RUN npm install --global yarn

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle install --jobs 4

# Copy the application code
COPY . .

EXPOSE 3000

ENTRYPOINT ["bash", "bin/entrypoint"]
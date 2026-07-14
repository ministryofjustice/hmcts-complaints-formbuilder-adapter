FROM ruby:3.4.10-alpine3.24

RUN apk add build-base postgresql-contrib postgresql-dev bash tzdata libcurl curl yaml-dev

ARG UID='1001'
RUN addgroup -S appgroup && \
  adduser -u ${UID} -S appuser -G appgroup

WORKDIR /app
ENV HOME=/app

RUN chown appuser:appgroup /app

COPY --chown=appuser:appgroup Gemfile Gemfile.lock .ruby-version ./

RUN gem install bundler

ENV BUNDLE_WITHOUT="development:test"
ARG BUNDLE_FLAGS="--jobs 2 --retry=3 --no-cache"
RUN bundle install ${BUNDLE_FLAGS}

COPY --chown=appuser:appgroup . .

ADD --chown=appuser:appgroup https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem ./rds-ca-2019-root.pem
ADD --chown=appuser:appgroup https://s3.amazonaws.com/rds-downloads/rds-ca-2015-root.pem ./rds-ca-2015-root.pem
ADD --chown=appuser:appgroup https://truststore.pki.rds.amazonaws.com/eu-west-2/eu-west-2-bundle.pem ./eu-west-bundle.pem
RUN cat ./rds-ca-2019-root.pem > ./rds-ca-bundle-root.crt
RUN cat ./rds-ca-2015-root.pem >> ./rds-ca-bundle-root.crt
RUN cat ./eu-west-bundle.pem >> ./rds-ca-bundle-root.crt
RUN chown appuser:appgroup ./rds-ca-bundle-root.crt

ENV APP_PORT=3000
EXPOSE $APP_PORT

ARG RAILS_ENV='production'
ENV RAILS_ENV=$RAILS_ENV

USER ${UID}

CMD ["sh", "-c", "bundle exec rake db:migrate:ignore_concurrent && bundle exec rails s -p ${APP_PORT} --binding=0.0.0.0"]

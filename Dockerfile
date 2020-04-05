FROM ruby:2.6-slim-buster

ENV APP_HOME /opt/app
ENV BUNDLE_BIN $GEM_HOME/bin
ENV PATH $BUNDLE_BIN:$PATH

ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_ENV production

ENV HOME $APP_HOME
ENV USER deployer
ENV PORT 3000

RUN apt update && \
    apt install -qq -y build-essential git libxml2-dev libsass-dev \
                       libpq-dev freetds-dev libmariadb-dev unixodbc-dev \
                       wget nodejs libxml2 libxml2-utils  \
                       openssl ssh tzdata alien libaio1 libaio-dev

ENV base_url    "https://download.oracle.com/otn_software/linux/instantclient/193000"
ENV basic_rpm   "oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm"
ENV sqlplus_rpm "oracle-instantclient19.3-sqlplus-19.3.0.0.0-1.x86_64.rpm"
ENV devel_rpm   "oracle-instantclient19.3-devel-19.3.0.0.0-1.x86_64.rpm"
ENV odbc_rpm    "oracle-instantclient19.3-odbc-19.3.0.0.0-1.x86_64.rpm"

RUN wget -q $base_url/$basic_rpm    \
            $base_url/$sqlplus_rpm  \
            $base_url/$devel_rpm    \
            $base_url/$odbc_rpm  && \
    alien -i --scripts $basic_rpm   \
                       $sqlplus_rpm \
                       $devel_rpm   \
                       $odbc_rpm && \
    rm $basic_rpm                   \
       $sqlplus_rpm                 \
       $devel_rpm                   \
       $odbc_rpm

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN gem update --system                 && \
    gem install bundler --no-document   && \
    bundle config set deployment 'true' && \
    bundle install --jobs 8

ADD . $APP_HOME/

RUN useradd -ms /bin/bash $USER

RUN touch /.odbc.ini
RUN chown -R $USER:$USER $APP_HOME /.odbc.ini

RUN bundle exec rails assets:precompile

RUN apt remove --purge -qq -y build-essential git wget alien ssh && \
    apt autoremove -y                                            && \
    apt autoclean -y                                             && \
    apt clean

USER $USER

EXPOSE $PORT

ENTRYPOINT [ "bin/rails" ]

CMD [ "server" ]

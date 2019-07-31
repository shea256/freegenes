FROM python:3.7.4-slim
ENV DEBIAN_FRONTEND noninteractive

# docker build -t vanessa/freegenes .

ARG ENABLE_LDAP=false
ARG ENABLE_PAM=false
ARG ENABLE_SAML=false

################################################################################
# CORE
# Do not modify this section

RUN apt-get update && apt-get install -y \
    cmake \
    git \
    libxmlsec1-dev \
    openssl \
    pkg-config \
    wget \
    vim

# Install Python requirements out of /tmp so not triggered if other contents of /code change
ADD requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /tmp/requirements.txt

ADD . /code/

################################################################################
# PLUGINS
# You are free to uncomment the plugins that you want to use

# Install LDAP (uncomment if wanted)
RUN if $ENABLE_LDAP; then pip install python3-ldap ; fi;
RUN if $ENABLE_LDAP; then pip install django-auth-ldap ; fi;

# Install PAM Authentication (uncomment if wanted)
RUN if $ENABLE_PAM; then pip install django-pam ; fi;

# Install SAML (uncomment if wanted)
RUN if $ENABLE_SAML; then pip install python3-saml ; fi;
RUN if $ENABLE_SAML; then pip install social-auth-core[saml] ; fi;

################################################################################
# BASE

RUN mkdir -p /code && mkdir -p /code/images
RUN mkdir -p /var/www/images && chmod -R 0755 /code/images/

WORKDIR /code
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD /code/run_uwsgi.sh

EXPOSE 3031

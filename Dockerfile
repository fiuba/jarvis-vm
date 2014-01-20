FROM ubuntu:precise

# Instalar dependencias
RUN apt-get update
RUN apt-get install -y python-software-properties unzip git curl gawk g++ make libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev

# Instalar VM de Pharo
RUN add-apt-repository -y ppa:pharo/stable
RUN apt-get update
RUN apt-get install -y pharo-vm-core

# Instalar imagen default de Pharo
RUN curl -SL http://files.pharo.org/image/20/Pharo-Image-2.0-latest.zip > Pharo-Image-2.0-latest.zip
RUN unzip Pharo-Image-2.0-latest.zip
RUN rm Pharo-Image-2.0-latest.zip

# Instalar RVM
RUN \curl -SL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"

# TODO: no debería hacer falta instalar la versión a mano (debería instalarlo automáticamente RVM)
RUN /bin/bash -l -c "rvm install ruby-1.9.3-p429"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Deploy Jarvis
# TODO: Sacar opción branch cuándo se hayan mergeado los cambios a master
RUN /bin/bash -l -c "git clone https://github.com/fiuba/jarvis.git --branch develop && cd jarvis && rvm gemset use jarvis --create && bundle install"

# TODO: levantar valores de configuracion
ENV ALFRED_API_URL http://alfred-preview.herokuapp.com/api
#ENV ALFRED_API_KEY <alfred api key>
#ENV DROPBOX_APP_KEY <dropbox app key>
#ENV DROPBOX_APP_SECRET <dropbox app secret>
#ENV DROPBOX_REQUEST_TOKEN_KEY <dropbox request token key>
#ENV DROPBOX_REQUEST_TOKEN_SECRET <dropbox token secret> 
#ENV DROPBOX_AUTH_TOKEN_KEY <dropbox auth token key>
#ENV DROPBOX_AUTH_TOKEN_SECRET <dropbox token secret>

# Correr Jarvis
ENTRYPOINT /bin/bash -l -c ruby jarvis/lib/corrector_app.rb

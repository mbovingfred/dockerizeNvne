# Base Image
FROM cafapi/java-postgres



# Installing required tools alpine
RUN apk --update add nano supervisor apache2
RUN apk add openrc --no-cache

# Adding Django Source code to container 
#ADD /service-config /src/service-config
#ADD /service-register /src/service-register
ADD /service-config/target/service-config-0.0.1-SNAPSHOT.jar /src/service-config/

ADD /service-register/target/service-register-0.0.1-SNAPSHOT.jar /src/service-register/

ADD /nvneBackend/target/webbackend-0.0.1-SNAPSHOT.jar /src/nvneBackend/

ADD /nvne/dist/nvne-front-web /var/www/nvne-front-web

# Adding supervisor configuration file to container
ADD /supervisor /src/supervisor

# Exposing container port for binding with host
EXPOSE 8888
EXPOSE 8761
EXPOSE 8081
EXPOSE 8080
EXPOSE 8080
EXPOSE 5432

# Using Django app directory as home
WORKDIR /src/service-config

# Postgres
RUN (addgroup -S postgres && adduser -S postgres -G postgres || true)
RUN mkdir -p /var/lib/postgresql/data
RUN mkdir -p /run/postgresql/
RUN chown -R postgres:postgres /run/postgresql/
RUN chmod -R 777 /var/lib/postgresql/data
RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf
#RUN su - postgres -c "initdb /var/lib/postgresql/data && pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log && psql --command \"CREATE DATABASE nvneNa9GEf9xh7UFKu9W;\""

# Initializing Redis server and Gunicorn server from supervisord
#CMD ["supervisord","-c","/src/supervisor/service_script.conf"]
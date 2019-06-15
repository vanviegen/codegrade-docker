FROM nikolaik/python-nodejs:python3.7-nodejs12
MAINTAINER Frank van Viegen (docker@vanviegen.net)

RUN apt-get update
RUN apt-get install -y postgresql virtualenv nginx rabbitmq-server
RUN git clone https://github.com/CodeGra-de/CodeGra.de.git

WORKDIR CodeGra.de
RUN virtualenv env -p `which python3`
RUN . env/bin/activate ; pip3 install uwsgi -r requirements.txt

RUN npm install

RUN k1=`< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16}` ; \
	k2=`< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16}` ; \
	k3=`< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16}` ; \
	echo "[Back-end]\nsqlalchemy_database_uri = postgresql:///codegrade\nsecret_key=$k1\nlti_secret_key=$k2\nhealth_key=$k3\n" > config.ini && \
	mkdir uploads && \
	mkdir mirror_uploads

ADD create-admin.sql .

RUN . env/bin/activate ; service postgresql start && \
	su postgres -c "createdb codegrade" && \
	su postgres -c "psql codegrade -c 'create role root superuser login'" && \
	make db_upgrade && \
	python3 manage.py seed_force && \
	su postgres -c "psql codegrade -f create-admin.sql"

RUN . env/bin/activate ; make build_front-end

ADD start.sh .
ADD uwsgi.ini .
ADD nginx.conf .

RUN echo "[Celery]\nbroker_url = amqp://guest:guest@localhost:5672/codegrade\n" >> config.ini

CMD [ "sh", "start.sh" ]


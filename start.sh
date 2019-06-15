#!/bin/sh

# exit on error
set -e

echo Starting rabbitmq
service rabbitmq-server start > /dev/null
rabbitmqctl add_vhost codegrade && \
rabbitmqctl set_permissions -p codegrade guest ".*" ".*" ".*"

echo Starting postgres
service postgresql start > /dev/null

echo Starting celery
. env/bin/activate
celery multi start psef_celery_worker1 --app=runcelery:celery

echo Starting nginx
nginx -c /CodeGra.de/nginx.conf

echo Starting uwsgi
uwsgi --ini uwsgi.ini



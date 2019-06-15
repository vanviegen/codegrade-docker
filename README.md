# CodeGrade Dockerfile

This is a Dockerfile (and related files) for quickly getting a [Codegrade](https://codegra.de/) environment up an running, just to play around with.

**WARNING:** All data will be lost when the container is stopped. I've only used and intended this for evaluating CodeGrade. If you want to use it for anything resembling production, you'll need to figure this out yourself. :-)

## Installing & running

```sh
docker build https://github.com/vanviegen/codegrade-docker.git -t codegrade && \
docker run -p 8080:80 -t codegrade
```

Wait a bit. About a minute after you see 'Starting uwsgi', you should be able to login:
  
  - URL: http://localhost:8080
  - User: admin
  - Password: admin

## Is this safe/reliable/..?

No.


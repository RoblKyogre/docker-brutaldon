FROM python:slim

RUN apt-get update && apt-get install -y \
  git \
  ca-certificates \
  build-essential

# init project
RUN git clone -b main https://gitlab.com/brutaldon/brutaldon.git /app
WORKDIR /app
RUN pip install pipenv
ENV PIPENV_VENV_IN_PROJECT=1
RUN pipenv install

# adjust settings for docker deployment
RUN sed -i 's/SECRET_KEY = "6lq9!52j^)=m89))umaphx9ac%)b$k^gs%x1rkk^v^$u9zjz$@"/SECRET_KEY = os.environ["SECRET_KEY"]/' brutaldon/settings.py && \
  sed -i 's/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = os.environ["ALLOWED_HOSTS"].split(\x27,\x27)/' brutaldon/settings.py && \
  sed -i 's/os.path.join(BASE_DIR, "db.sqlite3")/os.path.join(os.environ["DB_PATH"])/' brutaldon/settings.py && \
  sed -i 's/DEBUG = True/DEBUG = False/' brutaldon/settings.py && \
  sed -i 's/TIME_ZONE = "America\/New_York"/TIME_ZONE = os.environ["TZ"]/' brutaldon/settings.py && \
  sed -i 's/LANGUAGE_CODE = "en-us"/LANGUAGE_CODE = os.environ["LANGUAGE_CODE"]/' brutaldon/settings.py

COPY entrypoint.sh /entrypoint.sh
EXPOSE 8000
ENTRYPOINT "/entrypoint.sh"

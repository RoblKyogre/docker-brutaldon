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
COPY container.patch /container.patch
RUN git apply /container.patch && rm /container.patch

COPY entrypoint.sh /entrypoint.sh
EXPOSE 8000
ENTRYPOINT "/entrypoint.sh"

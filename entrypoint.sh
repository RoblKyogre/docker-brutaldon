#!/bin/bash
pipenv run python ./manage.py migrate
pipenv run python ./manage.py runserver --insecure 0.0.0.0:8000

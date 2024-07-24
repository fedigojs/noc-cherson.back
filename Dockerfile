FROM python:3.12-alpine3.19
LABEL maintainer="noc-herson.org"

ENV PYTHONUNBUFFERED=1
ENV PATH="/py/bin:$PATH"

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# Установка зависимостей
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp

# Создание пользователя django-user
RUN adduser -D -H -s /bin/bash django-user

# Переключение на пользователя django-user
USER django-user

FROM python:3.8-slim
ENV PYTHONUNBUFFERED 1

# chown /app and switch to non-root user
ENV USER=backend
RUN useradd -mrU -s /sbin/nologin -c "Docker image user" $USER && \
    install -d -o $USER -g $USER /app

COPY --chown=$USER:$USER backend/requirements/requirements.txt /app/requirements.txt

RUN set -ex && \
    pip install -r /app/requirements.txt && \
    rm -rf /app/requirements.txt

COPY --chown=$USER:$USER backend/backend /app/backend
COPY --chown=$USER:$USER backend/base /app/base
COPY --chown=$USER:$USER backend/manage.py /app/manage.py

USER ${USER}

EXPOSE 8000

WORKDIR /app

CMD ["gunicorn", "backend.wsgi", "--bind", "0.0.0.0:8000"]

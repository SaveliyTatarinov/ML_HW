FROM python:3.10-slim

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN pip install poetry && poetry config virtualenvs.create false && poetry install --no-dev
RUN pip install wandb

COPY ml_hw_4/ ./ml_hw_4/

CMD ["tail", "-f", "/dev/null"]
# Use lightweight Python base
FROM python:3.11-slim

WORKDIR /app

# install dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /app

ENV PORT=5000
ENV APP_VERSION="v1.0.0"

EXPOSE 5000

# Use gunicorn in production
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app", "--workers", "2"]

FROM python:3.12.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY test/ ./test/
ENTRYPOINT ["locust"]
EXPOSE 8089

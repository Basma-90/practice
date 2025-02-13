FROM python:3.9-alpine
RUN mkdir -p /app && chmod 777 /app
WORKDIR /app
COPY . .
RUN apk add --no-cache sqlite
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]

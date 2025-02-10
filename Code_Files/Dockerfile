FROM python:3
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
RUN python -c "from app import init_db; init_db()"
CMD ["python", "app.py"]

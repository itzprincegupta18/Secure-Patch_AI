FROM python:3.11-slim
RUN useradd -m -u 10001 securepatch
WORKDIR /app
COPY pyproject.toml README.md ./
COPY app ./app
COPY detector ./detector
COPY models ./models
COPY scripts ./scripts
COPY fixtures ./fixtures
RUN pip install --no-cache-dir 'pydantic>=2.7,<3' 'fastapi>=0.115,<1' 'uvicorn>=0.30,<1' 'python-multipart>=0.0.9,<1'
USER 10001
ENV PYTHONUNBUFFERED=1
EXPOSE 8000
CMD ["uvicorn","app.api.main:app","--host","0.0.0.0","--port","8000"]

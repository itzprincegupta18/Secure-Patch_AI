.PHONY: test lint scan ui api score benchmark security-check
PYTHON ?= python

test:
	$(PYTHON) -m pytest -q

scan:
	$(PYTHON) scripts/run_detection.py fixtures/firmware/01_buffer_overflow.c

score:
	$(PYTHON) scripts/security_score.py

benchmark:
	$(PYTHON) scripts/run_real_world_benchmark.py

security-check:
	$(PYTHON) scripts/run_security_checks.py

api:
	uvicorn app.api.main:app --reload

ui:
	streamlit run ui/streamlit_app.py

lint:
	ruff check .

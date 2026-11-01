# SecurePatch AI v5.0 — AI Patch Verified Release

> **We don't generate the firmware. We secure the firmware that already exists.**
>
> **AI proposes. Testing challenges. Verification decides.**

SecurePatch AI scans existing C/C++ IoT/embedded firmware, maps candidate vulnerabilities to CWE, generates constrained security patches through a model adapter, and uses an independent verifier for the final verdict.

## Architecture

```text
Existing Firmware
      │
      ├── Tree-sitter / custom rules / Semgrep / Cppcheck
      │
      ▼
Unified Findings ──► CWE/CVE Intelligence ──► AI Patch Proposal
      │                                           │
      │                                           ▼
      │                                    Schema + Policy Gate
      │                                           │
      │                                           ▼
      └──────────────────────────────────► Isolated Verifier
                                              │
                             compile → rescan → tests → resources
                                              │
                                              ▼
                                     VERIFIED / PARTIALLY VERIFIED /
                                     NOT VERIFIED / NEEDS HUMAN REVIEW

The LLM never sets the final security verdict.
```

## Current release status

| Area | Status |
|---|---|
| Deterministic candidate detection | IMPLEMENTED |
| CWE/evidence schema | IMPLEMENTED |
| Security score | IMPLEMENTED |
| Advisory-derived real-world regressions | IMPLEMENTED |
| Real-world exact-source provenance | PARTIAL / PROVENANCE_ONLY |
| Tree-sitter semantic analysis | PARTIAL |
| Semgrep/Cppcheck machine-output adapters | IMPLEMENTED when tools are installed |
| AI model adapters | IMPLEMENTED (Ollama + hosted JSON adapter) |
| Patch schema/policy | IMPLEMENTED |
| Independent verifier | IMPLEMENTED with Docker-required execution gates |
| FastAPI | IMPLEMENTED (MVP API) |
| Streamlit UI | IMPLEMENTED (MVP UI: upload, paste, ZIP scan, findings, score, JSON report) |
| Docker hardening | IMPLEMENTED as deployment defaults |
| Celery/Redis/PostgreSQL production orchestration | ROADMAP |
| OSV/NVD/SBOM enrichment | ROADMAP |
| Auth/RBAC/OIDC | ROADMAP |
| Full SARIF/PDF reporting | ROADMAP |

## Real-world benchmark policy

The release contains real, public vulnerability provenance from RIOT-OS and TianoCore EDK II. Recent cases include CVE-2026-97631, CVE-2026-27703, CVE-2025-66646, CVE-2026-107837 and CVE-2026-102692. **Advisory-derived pattern fixtures are explicitly not counted as exact-source detections.** Exact-source cases require immutable vulnerable/fixed revisions and are acquired with `scripts/acquire_real_world.py` in a network-enabled environment.

## Quick start (Python 3.11)

```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install pydantic pytest
python -m pytest -q
python scripts/run_real_world_benchmark.py
python scripts/security_score.py

# UI
python -m pip install -r requirements-ui.txt
python -m streamlit run ui/streamlit_app.py
```

Optional UI/API dependencies:

```powershell
python -m pip install fastapi uvicorn python-multipart streamlit
uvicorn app.api.main:app --reload
streamlit run ui/streamlit_app.py
```

## AI model

The architecture is model-agnostic. The development default is an Ollama endpoint using `qwen2.5-coder:7b`; the adapter can be replaced with another local model or a hosted JSON-compatible provider. AI output is Pydantic-validated and policy-checked before verification.

## Security rules

1. Do not execute untrusted source on the host.
2. Production verification uses the hardened Docker verifier profile with no network, dropped capabilities, read-only root filesystem, non-root execution and resource limits.
3. Treat source comments, strings and identifiers as untrusted data.
4. Limit repair attempts to 3 by default.
5. Never claim a CVE was detected unless the benchmark case records the provenance level.

See `docs/PRODUCTION_RELEASE_NOTES.md`, `docs/SECURITY_SCORE.md`, and `RELEASE_VALIDATION.md`.


## AI patch generation — mandatory path

When an AI adapter is configured, every detected finding is sent to the model.
The model must return the **complete patched source**, not a snippet or diff.
The application normalizes optional response metadata, computes the diff itself,
applies the patch policy, compiles it, runs ASan/UBSan when the environment
supports runtime instrumentation, statically rescans the result, and retries
failed repairs up to three times.

A model response containing only `patched_source` is accepted and its missing
metadata is safely derived. A response without `patched_source`, a truncated
source, or unchanged source is rejected.

The UI never shows `PATCH VERIFIED` from model confidence alone. The final
verdict comes from independent verification gates.

### Windows launch

From the project root:

```powershell
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m streamlit run ui\streamlit_app.py
```

For local AI patch generation:

```powershell
ollama pull qwen2.5-coder:7b
ollama list
```

Ollama must be running at `http://127.0.0.1:11434` unless `SECUREPATCH_OLLAMA_URL`
is changed in `.env`.

If MSYS2 UCRT64 GCC is installed but not on PATH, use:

```text
SECUREPATCH_COMPILER=C:\msys64\ucrt64\bin\gcc.exe
```

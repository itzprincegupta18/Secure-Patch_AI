# SecurePatch AI v4.0 — Local Release Validation

Validation performed before packaging this release.

## Automated tests

- `python -m pytest -q` → **16 passed**
- `python -m py_compile ui/streamlit_app.py app/core/scan_input.py` → **PASS**

## New-source detection test

A previously unseen local C snippet containing `strcpy()` and a variable `printf()` format was scanned.

Detected:

- CWE-120 — Unsafe string copy
- CWE-134 — Non-constant format string

## Independent patch verification test

A bounded replacement of `strcpy()` with `strncpy()` plus explicit NUL termination was passed through the local verifier.

- schema/policy: PASS
- compile: PASS
- rescan: PASS
- resource budget: PASS
- verdict: **VERIFIED**

## Real-world regression benchmark

The included catalog contains public CVE/advisory provenance for RIOT-OS, TianoCore EDK II and related embedded/firmware cases.

Current benchmark mode is intentionally conservative:

- advisory-derived regression pattern: counted as pattern evidence
- exact vendor source snapshot: not counted unless immutable vulnerable/fixed revisions are present
- current exact-source count: **0**

This is deliberate: the project does not claim exact CVE reproduction without reproducible source provenance.

## Security score

The score is calculated from the findings present in the scanned corpus. The full intentionally-vulnerable fixture corpus therefore scores low when all vulnerabilities remain open. A high score is not manufactured to make the dashboard look good.

## Known limitations

- Tree-sitter semantic findings are partial in this release.
- Semgrep/Cppcheck output parsing is partial.
- Docker verifier deployment wiring is partial even though the local verifier has independent compile/rescan/resource gates.
- Celery/Redis/PostgreSQL orchestration, OSV/NVD/SBOM enrichment, auth/RBAC and full reporting remain roadmap items.
- Exact-source public CVE benchmark reproduction requires network-enabled acquisition and pinned revisions.

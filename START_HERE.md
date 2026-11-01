# SecurePatch AI v4.0 — Start Here

## What the website does

This is a security scanner for **existing C/C++ IoT/embedded firmware**. It does not generate firmware.

Paste code or upload a C/C++ file and click **RUN COMPLETE SECURITY SCAN**.

The scan pipeline is:

1. Input validation
2. Deterministic custom security rules
3. Tree-sitter AST parsing when installed
4. Semgrep when installed
5. Cppcheck when installed
6. CWE mapping + evidence
7. Isolated compiler diagnostics through Docker (production policy)
8. ASan + UBSan instrumented build/runtime smoke test through Docker
9. Public CVE/dependency intelligence (best effort; never treated as proof of a CVE match)
10. Security score / grade
11. JSON security report

AI patching remains a separate stage. The AI never sets the final security verdict. Any patch must pass schema/policy checks and independent verification.

## Windows

```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements-ui.txt
python -m pytest -q
python -m streamlit run ui\streamlit_app.py
```

If PowerShell blocks activation, use the environment's Python directly:

```powershell
.\.venv\Scripts\python.exe -m pytest -q
.\.venv\Scripts\python.exe -m streamlit run ui\streamlit_app.py
```

## Docker requirement

The security policy does **not** execute uploaded/patched C/C++ on the Windows host. Compiler and sanitizer execution is Docker-isolated. If Docker is unavailable, the UI shows those gates as **SKIPPED**, never PASS.

Recommended Docker checks:

```powershell
docker --version
docker run --rm hello-world
```

The default compiler image is `gcc:14-bookworm`. Set `SECUREPATCH_COMPILER_IMAGE` if your environment uses an approved internal image.

## Important interpretation

- A static finding is a **candidate vulnerability**, not exploit proof.
- A clean ASan/UBSan smoke run is **not proof that every execution path is safe**.
- A CVE result from public intelligence is **not proof that the uploaded source is affected** unless exact source/version provenance is established.
- The independent verifier, not the LLM, owns the final patch verdict.

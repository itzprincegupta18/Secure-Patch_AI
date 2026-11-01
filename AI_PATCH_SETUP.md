# SecurePatch AI — Mandatory AI Patch Generation

## What changed — v5 AI patch pipeline
- Every detected finding triggers an AI remediation attempt.
- The AI must return the complete patched C/C++ source in `patched_source`.
- The application computes the unified diff itself, so the model cannot fabricate a diff.
- Each AI patch is policy-checked, compiled, sanitizer-tested (ASan/UBSan when a `main()` exists), and statically rescanned.
- Verification failures are fed back into the AI for up to 3 repair attempts.
- `PATCH VERIFIED` is shown only when independent verification passes.
- Local GCC/Clang verification is used for hackathon development when available; Docker remains the production isolation path.

## Recommended AI model
Use Ollama with Qwen2.5-Coder 7B.

```powershell
ollama pull qwen2.5-coder:7b
```

Keep Ollama running on its default endpoint:

```text
http://127.0.0.1:11434
```

The `.env.example` contains the corresponding settings. Copy it to `.env` if needed.

## Windows compiler
The project can use MSYS2 UCRT64 GCC directly:

```text
C:\msys64\ucrt64\bin\gcc.exe
```

Set `SECUREPATCH_COMPILER` to that path if GCC is not on PATH.

## Pipeline

```text
Existing C/C++ Firmware
        ↓
Deterministic Detection
        ↓
CWE Finding
        ↓
AI Patch Generation (Qwen2.5-Coder)
        ↓
Patch Policy
        ↓
GCC/Clang Compile
        ↓
ASan + UBSan
        ↓
Static Re-scan
        ↓
PASS → PATCH VERIFIED
FAIL → AI Repair → retry (max 3)
```

The AI never decides the final security verdict.


### Important troubleshooting

If you previously saw:

`4 validation errors for PatchProposal`

the old adapter was validating model JSON before filling optional metadata.
The v5 adapter now normalizes responses and only treats `patched_source` as
mandatory model output. The application still rejects empty, truncated, or
unchanged source.

If you see:

`AI patch generation failed: Cannot reach Ollama`

run:

```powershell
ollama list
ollama pull qwen2.5-coder:7b
```

and then relaunch:

```powershell
python -m streamlit run ui\streamlit_app.py
```

Do not run `python -m streamlit run streamlit_app.py` from the project root;
the UI file is `ui\streamlit_app.py`.

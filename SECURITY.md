# Security model

SecurePatch is defensive tooling. It analyzes source code supplied by an authorized user and must not execute it on the host.

## Non-negotiable controls

- Untrusted C/C++ is analyzed as data and executed only inside the isolated verifier profile in production.
- The verifier is non-root, network-disabled, capability-dropped, read-only-root, PID/memory/CPU/time limited.
- AI output is Pydantic-validated and then policy-checked.
- Source comments, strings and identifiers are treated as untrusted data for prompt construction.
- Repair attempts are bounded to 3 by default.
- Only the independent verifier can produce a security verdict.
- Real-world benchmark results require immutable provenance.

## Threats covered

Prompt injection, malicious patch output, oversized patches, check removal, malicious build scripts, resource exhaustion, network exfiltration, false benchmark claims, and detector false positives.

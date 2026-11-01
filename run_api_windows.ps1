$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Test-Path '.venv\Scripts\python.exe')) {
    Write-Host 'Creating Python 3.11 virtual environment...'
    py -3.11 -m venv .venv
}

& .venv\Scripts\python.exe -m pip install -r requirements-ui.txt
& .venv\Scripts\python.exe -m uvicorn app.api.main:app --host 127.0.0.1 --port 8000

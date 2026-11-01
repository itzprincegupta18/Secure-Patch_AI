$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Test-Path '.venv\Scripts\python.exe')) {
    Write-Host 'Creating Python 3.11 virtual environment...'
    py -3.11 -m venv .venv
}

& .venv\Scripts\python.exe -m pip install -r requirements-ui.txt
& .venv\Scripts\python.exe -m streamlit run ui\streamlit_app.py --server.headless true

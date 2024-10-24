#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    python -m venv venv
    source venv/bin/activate 
elif [[ "$OSTYPE" == "linux"* ]]; then
    python -m venv venv
    source venv/bin/activate 
elif [[ "$OSTYPE" == "cygwin"* ]]; then
    python -m venv venv
    source venv/bin/activate
elif [[ "$OSTYPE" == "msys"* ]]; then
    python -m venv venv
    source venv/bin/activate
else
    python -m venv venv
    venv\Scripts\activate
fi

pip install -r requirements.txt
pre-commit install
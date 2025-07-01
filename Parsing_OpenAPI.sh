grep -oP '^\s*"\K(/[a-zA-Z0-9._/-]+)(?=": \{)' openapi.json > paths.txt

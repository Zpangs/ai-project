#!/bin/bash

# Avbryt om xclip saknas
if ! command -v xclip &> /dev/null; then
    echo "xclip saknas! Installera med: sudo apt install xclip"
    exit 1
fi

TEMP_FILE=$(mktemp)

# Hittar relevanta källkodsfiler men ignorerar tunga cache- och databasmappar
find . -type d \( -name "node_modules" -o -name ".git" -o -name "__pycache__" -o -name "postgres_data" -o -name "venv" \) -prune -o \
       -type f \( -name "*.py" -o -name "*.jsx" -o -name "*.js" -o -name "*.yml" -o -name "Dockerfile" -o -name "package.json" -o -name "requirements.txt" \) -print | while read -r file; do
    echo -e "\n\n// ==========================================" >> "$TEMP_FILE"
    echo "// Fil: $file" >> "$TEMP_FILE"
    echo -e "// ==========================================\n" >> "$TEMP_FILE"
    cat "$file" >> "$TEMP_FILE"
done

# Skickar texten till urklippet
xclip -selection clipboard < "$TEMP_FILE"
rm "$TEMP_FILE"

echo "✅ Koden är samlad i urklippet! Tryck Ctrl+V för att klistra in i chatten."

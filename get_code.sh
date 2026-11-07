#!/bin/bash
# get_code.sh - Samlar kod från Django, React och Docker och kopierar till urklipp

# 1. Säkerställ att xclip är installerat i Linux Mint
if ! command -v xclip &> /dev/null; then
    echo "xclip saknas. Installera med: sudo apt install xclip"
    exit 1
fi

echo "Samlar in projektfiler..."

# 2. Hitta filer, ignorera skräpmappar, formatera med rubrik och skicka till urklippet
find . -type f \( -name "*.py" -o -name "*.jsx" -o -name "*.js" -o -name "Dockerfile*" -o -name "*.yml" -o -name "package.json" \) \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -path "*/__pycache__/*" \
  -not -path "*/postgres_data/*" \
  -not -path "*/venv/*" | while read -r file; do
    echo -e "\n\n--- FIL: $file ---"
    cat "$file"
done | xclip -selection clipboard

echo "✅ Klar! All viktig kod ligger nu i ditt urklipp (Ctrl+V)."

#!/bin/bash

# list.txtを読み込んで各行を処理
while IFS= read -r line || [ -n "$line" ]; do
    # 空行をスキップ
    line=$(echo "$line" | tr -d '\r' | xargs)
    if [ -z "$line" ]; then
        continue
    fi
    
    echo "Processing submodule: $line"
    
    # models/ 下の__init__.py以外の*.pyをコピー
    if [ -d "submodule/$line/models" ]; then
        mkdir -p models
        for file in "submodule/$line/models"/*.py; do
            if [ -f "$file" ] && [ "$(basename "$file")" != "__init__.py" ]; then
                cp "$file" models/
                echo "  Copied $(basename "$file") to models/"
            fi
        done
    fi
    
    # routers/ 下の__init__.py以外の*.pyをコピー
    if [ -d "submodule/$line/routers" ]; then
        mkdir -p routers
        for file in "submodule/$line/routers"/*.py; do
            if [ -f "$file" ] && [ "$(basename "$file")" != "__init__.py" ]; then
                cp "$file" routers/
                echo "  Copied $(basename "$file") to routers/"
            fi
        done
    fi
    
    # services/ 下の__init__.py以外の*.pyをコピー
    if [ -d "submodule/$line/services" ]; then
        mkdir -p services
        for file in "submodule/$line/services"/*.py; do
            if [ -f "$file" ] && [ "$(basename "$file")" != "__init__.py" ]; then
                cp "$file" services/
                echo "  Copied $(basename "$file") to services/"
            fi
        done
    fi
done < list.txt

# すべてのrequirements.txtを読み込んで重複なしで結合
echo "Merging requirements.txt files..."
temp_req="temp_requirements.txt"
rm -f "$temp_req"
touch "$temp_req"

# 各サブモジュールのrequirements.txtを読み込む
while IFS= read -r line || [ -n "$line" ]; do
    # 空行をスキップ
    line=$(echo "$line" | tr -d '\r' | xargs)
    if [ -z "$line" ]; then
        continue
    fi
    
    if [ -f "submodule/$line/requirements.txt" ]; then
        echo "  Reading requirements from submodule/$line/requirements.txt"
        cat "submodule/$line/requirements.txt" >> "$temp_req"
    fi
done < list.txt

# 重複を除去してソート（空行も除去）
if [ -s "$temp_req" ]; then
    sort -u "$temp_req" | grep -v '^[[:space:]]*$' > requirements.txt
    echo "Created requirements.txt with unique dependencies"
    rm -f "$temp_req"
else
    echo "No requirements.txt files found or all files are empty"
    rm -f "$temp_req"
fi

echo "Build completed!"


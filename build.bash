#!/bin/bash

# list.txtを読み込んで各行を処理
while IFS= read -r line || [ -n "$line" ]; do
    # 空行をスキップ
    if [ -z "$line" ]; then
        continue
    fi
    
    echo "Processing submodule: $line"
    
    # models/ 下の__init__.py以外の*.pyをコピー
    if [ -d "submodule/$line/models" ]; then
        mkdir -p models
        find "submodule/$line/models" -name "*.py" ! -name "__init__.py" -exec cp {} models/ \;
        echo "  Copied models from $line"
    fi
    
    # routers/ 下の__init__.py以外の*.pyをコピー
    if [ -d "submodule/$line/routers" ]; then
        mkdir -p routers
        find "submodule/$line/routers" -name "*.py" ! -name "__init__.py" -exec cp {} routers/ \;
        echo "  Copied routers from $line"
    fi
    
    # services/ 下の__init__.py以外の*.pyをコピー
    if [ -d "submodule/$line/services" ]; then
        mkdir -p services
        find "submodule/$line/services" -name "*.py" ! -name "__init__.py" -exec cp {} services/ \;
        echo "  Copied services from $line"
    fi
done < list.txt

# すべてのrequirements.txtを読み込んで重複なしで結合
echo "Merging requirements.txt files..."
temp_req=$(mktemp)

# 各サブモジュールのrequirements.txtを読み込む
while IFS= read -r line || [ -n "$line" ]; do
    # 空行をスキップ
    if [ -z "$line" ]; then
        continue
    fi
    
    if [ -f "submodule/$line/requirements.txt" ]; then
        cat "submodule/$line/requirements.txt" >> "$temp_req"
    fi
done < list.txt

# 重複を除去してソート（空行も除去）
if [ -f "$temp_req" ]; then
    sort -u "$temp_req" | grep -v '^[[:space:]]*$' > requirements.txt
    echo "Created requirements.txt with unique dependencies"
    rm "$temp_req"
else
    echo "No requirements.txt files found"
fi

echo "Build completed!"


# pR1Backend

認証APIとMenu管理APIを統合したFastAPIバックエンドアプリケーション

## 概要

このプロジェクトは、複数のサブモジュール（p51Auth、p52Menu）を統合したFastAPIアプリケーションです。

## CORS設定

フロントエンドアプリケーションからのアクセスを許可するため、CORS（Cross-Origin Resource Sharing）ミドルウェアが設定されています。

### 設定内容

`main.py`に以下のCORS設定が追加されています：

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # フロントエンドのオリジン
    allow_credentials=True,
    allow_methods=["*"],  # すべてのHTTPメソッドを許可
    allow_headers=["*"],  # すべてのヘッダーを許可
)
```

### 設定項目の説明

- **`allow_origins`**: アクセスを許可するオリジンのリスト
  - 現在は `http://localhost:5173`（Viteのデフォルトポート）を許可
  - 他のオリジンも許可する場合は、リストに追加してください
  - 例: `allow_origins=["http://localhost:5173", "http://localhost:3000"]`

- **`allow_credentials`**: クッキーや認証情報を含むリクエストを許可
  - `True`に設定することで、認証情報を含むリクエストが可能になります

- **`allow_methods`**: 許可するHTTPメソッド
  - `["*"]`で全てのメソッド（GET, POST, PUT, DELETE, PATCH, OPTIONSなど）を許可
  - 特定のメソッドのみ許可する場合は、`["GET", "POST"]`のように指定

- **`allow_headers`**: 許可するリクエストヘッダー
  - `["*"]`で全てのヘッダーを許可
  - 特定のヘッダーのみ許可する場合は、`["Content-Type", "Authorization"]`のように指定

### 本番環境での注意事項

本番環境では、セキュリティのため以下の点に注意してください：

1. **`allow_origins`**: 特定のドメインのみを許可し、`["*"]`は使用しない
2. **`allow_methods`**: 必要なメソッドのみを許可
3. **`allow_headers`**: 必要なヘッダーのみを許可

例：
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com", "https://www.yourdomain.com"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Content-Type", "Authorization"],
)
```


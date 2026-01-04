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

## IPv4/IPv6対応

サーバーはIPv4とIPv6の両方で動作するように設定されています。

### 設定内容

`main.py`の`uvicorn.run()`で以下の設定を使用しています：

```python
uvicorn.run(app, host="::", port=API_PORT)
```

### 設定の説明

- **`host="::"`**: IPv6の全インターフェース（全ネットワークインターフェース）を指定
  - 多くのシステムでは、IPv6ソケットがIPv4も処理できるため（dual-stack）、IPv4とIPv6の両方で動作します
  - これにより、IPv4とIPv6の両方からのアクセスが可能になります

### アクセス方法

サーバー起動後、以下のURLでアクセスできます：

- **IPv4**:
  - `http://127.0.0.1:8000`
  - `http://localhost:8000`（IPv4が優先される場合）

- **IPv6**:
  - `http://[::1]:8000`（IPv6のループバックアドレス）
  - `http://localhost:8000`（IPv6が有効で優先される場合）

### 注意事項

1. **IPv6が無効なシステム**: システムがIPv6をサポートしていない場合、`host="::"`では起動できない可能性があります
   - その場合は、`host="0.0.0.0"`（IPv4のみ）に変更してください

2. **IPv4のみが必要な場合**: IPv4のみで動作させる場合は、以下のように設定してください：
   ```python
   uvicorn.run(app, host="0.0.0.0", port=API_PORT)
   ```

3. **特定のインターフェースのみ**: 特定のネットワークインターフェースのみでリッスンする場合は、そのインターフェースのIPアドレスを指定してください：
   ```python
   uvicorn.run(app, host="192.168.1.100", port=API_PORT)  # IPv4の特定アドレス
   uvicorn.run(app, host="2001:db8::1", port=API_PORT)   # IPv6の特定アドレス
   ```


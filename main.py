# -*- coding: utf-8 -*-
"""
FastAPIアプリケーション（認証API + Menu API 統合版）
制御部分（エントリーポイント）
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth, menu

# ポート番号を外出し
API_PORT = 8000

# FastAPIアプリケーションを作成
app = FastAPI(
    title="統合API",
    description="認証API と Menu管理API を統合したWeb API",
    version="1.0.0"
)

# CORSミドルウェアを追加
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # フロントエンドのオリジン
    allow_credentials=True,
    allow_methods=["*"],  # すべてのHTTPメソッドを許可
    allow_headers=["*"],  # すべてのヘッダーを許可
)

# ルーターを登録
app.include_router(auth.router)
app.include_router(menu.router)

@app.get("/")
async def root() -> dict[str, str]:
    """ルートエンドポイント"""
    return {"message": "統合APIサーバー（認証 + Menu）"}

if __name__ == "__main__":
    import uvicorn
    # IPv6でも動作するように設定（::はIPv6の全インターフェース、多くのシステムでIPv4も処理可能）
    uvicorn.run(app, host="::", port=API_PORT)

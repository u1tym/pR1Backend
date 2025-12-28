# -*- coding: utf-8 -*-
"""
FastAPIアプリケーション（認証API + Menu API 統合版）
制御部分（エントリーポイント）
"""

from fastapi import FastAPI
from routers import auth, menu

# ポート番号を外出し
API_PORT = 8000

# FastAPIアプリケーションを作成
app = FastAPI(
    title="統合API",
    description="認証API と Menu管理API を統合したWeb API",
    version="1.0.0"
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
    uvicorn.run(app, host="0.0.0.0", port=API_PORT)

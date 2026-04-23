import requests, urllib.parse, traceback
from fastapi import FastAPI, HTTPException

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/get_move")
async def get_move(data: dict):
    try:
        fen = data.get("fen")
        encoded = urllib.parse.quote(fen)
        url = f"https://www.chessdb.cn/cdb.php?action=queryall&board={encoded}"
        resp = requests.get(url, timeout=3.0)
        if resp.status_code == 200:
            moves = resp.json()
            if moves:
                # выбираем ход с максимальной оценкой
                best = max(moves, key=lambda x: x.get('score', -9999))
                return {"move": best['move']}
        raise HTTPException(status_code=500, detail="No move")
    except Exception as e:
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

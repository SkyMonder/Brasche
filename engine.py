import os, chess, chess.engine
from fastapi import FastAPI, HTTPException

app = FastAPI()
engine = None

def init_engine():
    global engine
    engine = chess.engine.SimpleEngine.popen_uci("./engine")
    # Обратите внимание: MultiPV не устанавливаем через configure!
    engine.configure({
        "Skill Level": 20,
        "Hash": 128,
        "Threads": 1,
        "Move Overhead": 50,
    })

@app.on_event("startup")
async def startup():
    init_engine()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/get_move")
async def get_move(data: dict):
    try:
        fen = data.get("fen")
        move_time = data.get("move_time", 1.0)
        board = chess.Board(fen)
        # Используем analyse с multipv=2 для получения двух лучших ходов
        analysis = engine.analyse(board, chess.engine.Limit(time=move_time), multipv=2)
        if analysis and len(analysis) > 0:
            best_move = analysis[0]['pv'][0]
            return {"move": best_move.uci()}
        raise HTTPException(status_code=500, detail="No analysis")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

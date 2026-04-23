import os, chess, chess.engine
from fastapi import FastAPI, HTTPException

app = FastAPI()
engine = None

def init_engine():
    global engine
    engine = chess.engine.SimpleEngine.popen_uci("./engine")
    engine.configure({
        "Skill Level": 20,
        "Hash": 256,
        "Threads": 1,
        "Move Overhead": 50,
        "MultiPV": 2,           # анализировать два лучших хода, выбирать агрессивный
        "UCI_ShowWDL": True,    # показывать вероятности, влияет на выбор
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
        # Используем анализ, чтобы выбрать ход с лучшей атакующей оценкой
        analysis = engine.analyse(board, chess.engine.Limit(time=move_time), multipv=2)
        best_move = analysis[0]['pv'][0] if analysis else None
        if not best_move:
            result = engine.play(board, chess.engine.Limit(time=move_time))
            best_move = result.move
        return {"move": best_move.uci() if best_move else None}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

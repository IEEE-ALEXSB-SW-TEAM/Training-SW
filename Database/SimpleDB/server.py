
import uvicorn
import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from sdb import write, read

DB_PATH = os.environ.get("SDB_PATH", "sdb.log")
    
app = FastAPI(title="Tiny Append-Only KV Demo")


class WriteRequest(BaseModel):
    key: str
    value: str


@app.get("/")
def home():
    return {"message": "Welcome! Use POST /write and GET /read?key=... (append-only KV demo)"}


@app.post("/write")
def write_endpoint(req: WriteRequest):
    try:
        nbytes = write(DB_PATH, req.key, req.value)
        return {"ok": True, "bytes_written": nbytes, "db_path": DB_PATH}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.get("/read")
def read_endpoint(key: str):
    val = read(DB_PATH, key)
    if val is None:
        raise HTTPException(status_code=404, detail="key not found")
    return {"key": key, "value": val}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import uvicorn

app = FastAPI()

@app.get("/", response_class=PlainTextResponse)
async def hello():
    return "Hello world"

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)

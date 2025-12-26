from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routers import formulas, indices

# Optional: Database for baskets feature (disabled for now)
try:
    from database.session import Base, engine
    from routers import baskets
    Base.metadata.create_all(bind=engine)
    BASKETS_ENABLED = True
except Exception as e:
    print(f"⚠️  Database not available, baskets feature disabled: {e}")
    BASKETS_ENABLED = False

app = FastAPI(title="VS Fintech Platform API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Include baskets router only if database is available
if BASKETS_ENABLED:
    app.include_router(baskets.router)

app.include_router(formulas.router)
app.include_router(indices.router)


@app.get("/health")
def health_check():
    return {"status": "ok"}


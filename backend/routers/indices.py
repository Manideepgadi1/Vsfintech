from pathlib import Path

import pandas as pd
from fastapi import APIRouter, HTTPException


router = APIRouter(prefix="/indices", tags=["indices"])

CSV_PATH = Path("/mnt/data/Latest_Indices_rawdata_14112025.csv")


@router.get("/latest")
def get_latest_indices(limit: int = 100):
    if not CSV_PATH.exists():
        raise HTTPException(status_code=404, detail="Index data not available")

    df = pd.read_csv(CSV_PATH)
    if "Date" in df.columns:
        df = df.sort_values("Date", ascending=False)

    records = df.head(limit).to_dict(orient="records")
    return {"count": len(records), "items": records}


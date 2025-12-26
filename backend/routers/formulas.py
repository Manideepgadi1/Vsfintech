from fastapi import APIRouter, HTTPException


router = APIRouter(prefix="/formulas", tags=["formulas"])


@router.post("/evaluate")
def evaluate_formula(payload: dict):
    expression = payload.get("expression")
    variables = payload.get("variables", {})
    if not isinstance(expression, str):
        raise HTTPException(status_code=400, detail="Invalid expression")

    # Placeholder safe evaluation – replace with manager-provided logic
    try:
        allowed_names: dict[str, float] = {}
        allowed_names.update(variables)
        value = eval(expression, {"__builtins__": {}}, allowed_names)
    except Exception as exc:  # noqa: BLE001
        raise HTTPException(status_code=400, detail=f"Evaluation error: {exc}") from exc

    return {"value": float(value)}


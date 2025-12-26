# VS Fintech Platform

Premium fintech web platform with a modern React + Vite + Tailwind frontend and FastAPI + PostgreSQL backend.

## Stack

- Frontend: React 18, Vite, TypeScript, TailwindCSS, React Router, Axios
- Backend: FastAPI, SQLAlchemy, PostgreSQL, Pandas

## Structure

- `frontend/` – SPA with home, baskets, and basket detail pages
- `backend/` – FastAPI app with modular routers and Postgres integration

## Running locally

### Backend

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn backend.main:app --reload --port 8000
```

Ensure PostgreSQL is running and update `backend/database/config.py` if needed.

### Frontend

```powershell
cd frontend
npm install
npm run dev
```

The app will be available at `http://localhost:5173` and will talk to the backend at `http://localhost:8000`.

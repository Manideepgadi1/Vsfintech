from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from database.session import get_db
from models.basket import Basket
from schemas.basket import BasketCreate, BasketRead, BasketUpdate


router = APIRouter(prefix="/baskets", tags=["baskets"])


@router.get("/", response_model=List[BasketRead])
def list_baskets(db: Session = Depends(get_db)):
    return db.query(Basket).all()


@router.get("/{basket_id}", response_model=BasketRead)
def get_basket(basket_id: int, db: Session = Depends(get_db)):
    basket = db.query(Basket).get(basket_id)
    if not basket:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Basket not found")
    return basket


@router.post("/", response_model=BasketRead, status_code=status.HTTP_201_CREATED)
def create_basket(payload: BasketCreate, db: Session = Depends(get_db)):
    basket = Basket(
        name=payload.name,
        description=payload.description,
        tags=",".join(payload.tags),
    )
    db.add(basket)
    db.commit()
    db.refresh(basket)
    return basket


@router.put("/{basket_id}", response_model=BasketRead)
def update_basket(basket_id: int, payload: BasketUpdate, db: Session = Depends(get_db)):
    basket = db.query(Basket).get(basket_id)
    if not basket:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Basket not found")

    basket.name = payload.name
    basket.description = payload.description
    basket.tags = ",".join(payload.tags)
    db.commit()
    db.refresh(basket)
    return basket


@router.delete("/{basket_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_basket(basket_id: int, db: Session = Depends(get_db)):
    basket = db.query(Basket).get(basket_id)
    if not basket:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Basket not found")
    db.delete(basket)
    db.commit()


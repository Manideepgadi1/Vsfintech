from pydantic import BaseModel


class BasketBase(BaseModel):
    name: str
    description: str | None = None
    tags: list[str] = []


class BasketCreate(BasketBase):
    pass


class BasketUpdate(BasketBase):
    pass


class BasketRead(BasketBase):
    id: int

    class Config:
        orm_mode = True

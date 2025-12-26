import { apiClient } from './apiClient';

export interface BasketPayload {
  name: string;
  description: string;
  tags: string[];
}

export async function fetchBaskets() {
  const { data } = await apiClient.get('/baskets');
  return data;
}

export async function fetchBasketById(id: string) {
  const { data } = await apiClient.get(`/baskets/${id}`);
  return data;
}

export async function createBasket(payload: BasketPayload) {
  const { data } = await apiClient.post('/baskets', payload);
  return data;
}

export async function updateBasket(id: string, payload: BasketPayload) {
  const { data } = await apiClient.put(`/baskets/${id}`);
  return data;
}

export async function deleteBasket(id: string) {
  await apiClient.delete(`/baskets/${id}`);
}

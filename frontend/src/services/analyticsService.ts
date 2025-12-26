import { apiClient } from './apiClient';

export async function fetchIndexData() {
  const { data } = await apiClient.get('/indices/latest');
  return data;
}

export async function evaluateFormula(payload: { expression: string; variables: Record<string, number> }) {
  const { data } = await apiClient.post('/formulas/evaluate', payload);
  return data;
}

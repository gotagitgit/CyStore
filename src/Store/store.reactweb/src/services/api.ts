import axios from 'axios';
import type { Consumer, Product, Cart } from '../types';

const ACCOUNT_SERVICE_API_BASE = import.meta.env.VITE_ACCOUNT_SERVICE_API_BASE || 'http://localhost:8081/api';
const INVENTORY_SERVICE_API_BASE = import.meta.env.VITE_INVENTORY_SERVICE_API_BASE || 'http://localhost:8082/api';
const SHOPPING_SERVICE_API_BASE = import.meta.env.VITE_SHOPPING_SERVICE_API_BASE || 'http://localhost:8083/api';

export const fetchConsumer = async (id: number): Promise<Consumer> => {
  const response = await axios.get(`${ACCOUNT_SERVICE_API_BASE}/consumers/${id}`);
  return response.data;
};

export const fetchProducts = async (): Promise<Product[]> => {
  const response = await axios.get(`${INVENTORY_SERVICE_API_BASE}/products`);
  return response.data;
};

export const fetchCart = async (id: number): Promise<Cart> => {
  const response = await axios.get(`${SHOPPING_SERVICE_API_BASE}/cart/${id}`);
  return response.data;
};
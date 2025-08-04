export interface Consumer {
  id: number;
  firstname: string;
  surname: string;
}

export interface Product {
  id: number;
  name: string;
  sku: string;
  regularPrice: number;
}

export interface CartItem {
  productId: number;
  quantity: number;
}

export interface Cart {
  id: number;
  consumerId: number;
  items: CartItem[];
}

export interface Commerce {
  user: Consumer;
  products: Product[];
  cart: Cart;
}
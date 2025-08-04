import React from 'react';
import Product from './Product';
import type { Product as ProductType } from '../types';

interface ProductListProps {
  products: ProductType[];
  onAddToCart: (product: ProductType) => void;
}

const ProductList: React.FC<ProductListProps> = ({ products, onAddToCart }) => {
  return (
    <div className="row text-center">
      {products.map(product => (
        <Product
          key={product.id}
          product={product}
          onAddToCart={onAddToCart}
        />
      ))}
    </div>
  );
};

export default ProductList;
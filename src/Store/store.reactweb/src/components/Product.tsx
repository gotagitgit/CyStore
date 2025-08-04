import React from 'react';
import type { Product as ProductType } from '../types';

interface ProductProps {
  product: ProductType;
  onAddToCart: (product: ProductType) => void;
}

const Product: React.FC<ProductProps> = ({ product, onAddToCart }) => {
  return (
    <div className="col-lg-3 col-md-6 mb-4">
      <div className="card">
        <img className="card-img-top" src="http://placehold.it/500x325" alt="" />
        <div className="card-body">
          <h4 className="card-title">{product.name}</h4>
          <div className="card-text">{product.sku}</div>
          <div className="card-text">${product.regularPrice}</div>
        </div>
        <div className="card-footer">
          <button 
            className="btn btn-primary" 
            onClick={() => onAddToCart(product)}
          >
            Add to Cart
          </button>
        </div>
      </div>
    </div>
  );
};

export default Product;
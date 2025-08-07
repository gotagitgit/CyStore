import React from 'react';

interface Product {
  id: number;
  name: string;
  description: string;
  sku: string;
  regularPrice: number;
  discountPrice: number;
  quantity: number;
}

interface ProductCardProps {
  product: Product;
  onAddToCart: (product: Product) => void;
}

const ProductCard: React.FC<ProductCardProps> = ({ product, onAddToCart }) => {
  return (
    <div className="product-card">
      <h3>{product.name}</h3>
      <p className="sku">SKU: {product.sku}</p>
      <div className="price">
        <span className="regular-price">${product.regularPrice}</span>
        <span className="discount-price">${product.discountPrice}</span>
      </div>
      <p className="quantity">In Stock: {product.quantity}</p>
      <button 
        className="add-to-cart-btn"
        onClick={() => onAddToCart(product)}
        disabled={product.quantity === 0}
      >
        Add to Cart
      </button>
    </div>
  );
};

export default ProductCard;
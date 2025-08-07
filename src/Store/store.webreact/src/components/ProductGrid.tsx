import React from 'react';
import ProductCard from './ProductCard';

interface Product {
  id: number;
  name: string;
  description: string;
  sku: string;
  regularPrice: number;
  discountPrice: number;
  quantity: number;
}

interface ProductGridProps {
  products: Product[];
  onAddToCart: (product: Product) => void;
}

const ProductGrid: React.FC<ProductGridProps> = ({ products, onAddToCart }) => {
  return (
    <section className="product-grid-section">
      <h2>Our Products</h2>
      <div className="product-grid">
        {products.map(product => (
          <ProductCard 
            key={product.id} 
            product={product} 
            onAddToCart={onAddToCart}
          />
        ))}
      </div>
    </section>
  );
};

export default ProductGrid;
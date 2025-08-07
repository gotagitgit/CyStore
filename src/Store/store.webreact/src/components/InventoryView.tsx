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

interface InventoryViewProps {
  products: Product[];
}

const InventoryView: React.FC<InventoryViewProps> = ({ products }) => {
  return (
    <div className="service-view">
      <h2>Inventory Service</h2>
      <p className="service-description">Product catalog and stock management</p>
      <div className="service-grid">
        {products.map(product => (
          <div key={product.id} className="service-card">
            <h3>{product.name}</h3>
            <p>SKU: {product.sku}</p>
            <p>Regular: ${product.regularPrice}</p>
            <p>Discount: ${product.discountPrice}</p>
            <p>Stock: {product.quantity}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default InventoryView;
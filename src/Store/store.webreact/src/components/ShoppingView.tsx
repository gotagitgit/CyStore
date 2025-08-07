import React from 'react';

interface CartItem {
  id: number;
  name: string;
  sku: string;
  discountPrice: number;
  quantity: number;
}

interface ShoppingViewProps {
  cartItems: CartItem[];
}

const ShoppingView: React.FC<ShoppingViewProps> = ({ cartItems }) => {
  return (
    <div className="service-view">
      <h2>Shopping Service</h2>
      <p className="service-description">Cart management and order processing</p>
      <div className="service-grid">
        {cartItems.map(item => (
          <div key={item.id} className="service-card">
            <h3>{item.name}</h3>
            <p>SKU: {item.sku}</p>
            <p>Price: ${item.discountPrice}</p>
            <p>Quantity: {item.quantity}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ShoppingView;
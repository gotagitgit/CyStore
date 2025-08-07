import React from 'react';

interface CartItem {
  id: number;
  name: string;
  sku: string;
  discountPrice: number;
  quantity: number;
}

interface CartProps {
  items: CartItem[];
  onRemoveItem: (id: number) => void;
}

const Cart: React.FC<CartProps> = ({ items, onRemoveItem }) => {
  const total = items.reduce((sum, item) => sum + (item.discountPrice * item.quantity), 0);

  return (
    <section className="cart-section">
      <h2>Shopping Cart</h2>
      {items.length === 0 ? (
        <p className="empty-cart">Your cart is empty</p>
      ) : (
        <>
          <div className="cart-items">
            {items.map(item => (
              <div key={item.id} className="cart-item">
                <div className="item-info">
                  <h4>{item.name}</h4>
                  <p>SKU: {item.sku}</p>
                  <p>Quantity: {item.quantity}</p>
                </div>
                <div className="item-price">
                  <span>${item.discountPrice}</span>
                  <button 
                    className="remove-btn"
                    onClick={() => onRemoveItem(item.id)}
                  >
                    Remove
                  </button>
                </div>
              </div>
            ))}
          </div>
          <div className="cart-total">
            <h3>Total: ${total.toFixed(2)}</h3>
            <button className="checkout-btn">Checkout</button>
          </div>
        </>
      )}
    </section>
  );
};

export default Cart;
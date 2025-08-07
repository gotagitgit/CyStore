import React from 'react';

interface HeaderProps {
  cartItemCount: number;
  currentView: string;
  onViewChange: (view: string) => void;
}

const Header: React.FC<HeaderProps> = ({ cartItemCount, currentView, onViewChange }) => {
  return (
    <header className="header">
      <div className="container">
        <h1 className="logo">CyStore</h1>
        <nav className="nav">
          <button 
            className={currentView === 'store' ? 'nav-btn active' : 'nav-btn'}
            onClick={() => onViewChange('store')}
          >
            Store
          </button>
          <button 
            className={currentView === 'accounts' ? 'nav-btn active' : 'nav-btn'}
            onClick={() => onViewChange('accounts')}
          >
            Accounts
          </button>
          <button 
            className={currentView === 'inventory' ? 'nav-btn active' : 'nav-btn'}
            onClick={() => onViewChange('inventory')}
          >
            Inventory
          </button>
          <button 
            className={currentView === 'shopping' ? 'nav-btn active' : 'nav-btn'}
            onClick={() => onViewChange('shopping')}
          >
            Shopping
          </button>
          <span className="cart-counter">Cart ({cartItemCount})</span>
        </nav>
      </div>
    </header>
  );
};

export default Header;
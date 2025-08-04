import React, { useState, useEffect } from 'react';
import NavBar from './components/NavBar';
import JumboTron from './components/JumboTron';
import ProductList from './components/ProductList';
import Footer from './components/Footer';
import { fetchConsumer, fetchProducts, fetchCart } from './services/api';
import type { Product, Commerce } from './types';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';

const App: React.FC = () => {
  const [commerce, setCommerce] = useState<Commerce>({
    user: { id: 0, firstname: '', surname: '' },
    products: [],
    cart: { id: 0, consumerId: 0, items: [] }
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      try {
        const [user, products, cart] = await Promise.all([
          fetchConsumer(5),
          fetchProducts(),
          fetchCart(30)
        ]);
        
        setCommerce({ user, products, cart });
      } catch (error) {
        console.error('Error loading data:', error);
        // Fallback data
        setCommerce({
          user: { id: 5, firstname: 'John', surname: 'Doe' },
          products: [
            { id: 1, name: 'Sample Product 1', sku: 'SKU001', regularPrice: 29.99 },
            { id: 2, name: 'Sample Product 2', sku: 'SKU002', regularPrice: 39.99 }
          ],
          cart: { id: 30, consumerId: 5, items: [] }
        });
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  const handleAddToCart = (product: Product) => {
    console.log('Adding to cart:', product);
    // TODO: Implement cart functionality
  };

  if (loading) {
    return (
      <div className="d-flex justify-content-center mt-5">
        <div className="spinner-border" role="status">
          <span className="sr-only">Loading...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="App">
      <NavBar consumer={commerce.user} />
      <div className="container" style={{ marginTop: '80px' }}>
        <JumboTron />
        <ProductList products={commerce.products} onAddToCart={handleAddToCart} />
      </div>
      <Footer />
    </div>
  );
};

export default App;
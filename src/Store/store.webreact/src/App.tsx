import { useState } from 'react'
import './App.css'
import Header from './components/Header'
import UserProfile from './components/UserProfile'
import AccountsView from './components/AccountsView'
import InventoryView from './components/InventoryView'
import ShoppingView from './components/ShoppingView'

interface Consumer {
  id: number
  firstname: string
  surname: string
  age: number
}

interface Product {
  id: number
  name: string
  description: string
  sku: string
  regularPrice: number
  discountPrice: number
  quantity: number
}

function App() {
  const [currentView, setCurrentView] = useState('store')
  const [consumers, setConsumers] = useState<Consumer[]>([])
  const [currentUser, setCurrentUser] = useState<Consumer | null>(null)
  const [products, setProducts] = useState<Product[]>([])
  const [cartItems, setCartItems] = useState<Product[]>([])
  const [loading, setLoading] = useState(false)

  const fetchConsumers = async () => {
    setLoading(true)
    try {
      const response = await fetch('/api/consumers')
      const data = await response.json()
      setConsumers(data)
      setCurrentUser(data[0] || null)
    } catch (error) {
      console.error('Error fetching consumers:', error)
    } finally {
      setLoading(false)
    }
  }

  const fetchProducts = async () => {
    setLoading(true)
    try {
      const response = await fetch('/api/products')
      const data = await response.json()
      setProducts(data)
    } catch (error) {
      console.error('Error fetching products:', error)
    } finally {
      setLoading(false)
    }
  }

  const fetchCart = async () => {
    setLoading(true)
    try {
      const response = await fetch('/api/cart/100')
      const data = await response.json()
      setCartItems(data.items || [])
    } catch (error) {
      console.error('Error fetching cart:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleViewChange = (view: string) => {
    setCurrentView(view)
    switch (view) {
      case 'accounts':
        if (consumers.length === 0) fetchConsumers()
        break
      case 'inventory':
        if (products.length === 0) fetchProducts()
        break
      case 'shopping':
        if (cartItems.length === 0) fetchCart()
        break
    }
  }

  const renderCurrentView = () => {
    switch (currentView) {
      case 'accounts':
        return <AccountsView consumers={consumers} />
      case 'inventory':
        return <InventoryView products={products} />
      case 'shopping':
        return <ShoppingView cartItems={cartItems} />
      default:
        return <UserProfile user={currentUser} />
    }
  }

  if (loading) {
    return <div className="loading">Loading CyStore...</div>
  }

  return (
    <div className="app">
      <Header 
        cartItemCount={cartItems.length} 
        currentView={currentView}
        onViewChange={handleViewChange}
      />
      <main className="main">
        {renderCurrentView()}
      </main>
    </div>
  )
}

export default App

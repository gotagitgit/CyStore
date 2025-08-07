import { useState, useEffect } from 'react'
import './App.css'
import Header from './components/Header'
import UserProfile from './components/UserProfile'
import ProductGrid from './components/ProductGrid'
import Cart from './components/Cart'
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
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [consumersRes, productsRes, cartRes] = await Promise.all([
          fetch('http://localhost:8081/api/consumers'),
          fetch('http://localhost:8082/api/products'),
          fetch('http://localhost:8083/api/cart/100')
        ])

        const consumersData = await consumersRes.json()
        const productsData = await productsRes.json()
        const cartData = await cartRes.json()

        setConsumers(consumersData)
        setCurrentUser(consumersData[0] || null)
        setProducts(productsData)
        setCartItems(cartData.items || [])
      } catch (error) {
        console.error('Error fetching data:', error)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  const handleAddToCart = (product: Product) => {
    setCartItems(prev => {
      const existing = prev.find(item => item.id === product.id)
      if (existing) {
        return prev.map(item => 
          item.id === product.id 
            ? { ...item, quantity: item.quantity + 1 }
            : item
        )
      }
      return [...prev, { ...product, quantity: 1 }]
    })
  }

  const handleRemoveFromCart = (id: number) => {
    setCartItems(prev => prev.filter(item => item.id !== id))
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
        onViewChange={setCurrentView}
      />
      <main className="main">
        {renderCurrentView()}
      </main>
    </div>
  )
}

export default App

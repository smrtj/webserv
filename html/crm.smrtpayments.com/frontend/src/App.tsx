import { Link, Route, Routes } from 'react-router-dom'
import Dashboard from './pages/Dashboard'
import Contacts from './pages/Contacts'
import Companies from './pages/Companies'
import Deals from './pages/Deals'
import './App.css'

export default function App() {
  return (
    <div>
      <nav className="flex gap-4 bg-sage-light p-4 text-white">
        <Link to="/">Dashboard</Link>
        <Link to="/contacts">Contacts</Link>
        <Link to="/companies">Companies</Link>
        <Link to="/deals">Deals</Link>
      </nav>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/contacts" element={<Contacts />} />
        <Route path="/companies" element={<Companies />} />
        <Route path="/deals" element={<Deals />} />
      </Routes>
    </div>
  )
}

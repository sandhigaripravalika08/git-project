import React from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import Search from './Components/Search'
import MarksResult from './Components/MarksResult'

export default function App() {
  return (
    <div>App
      <BrowserRouter>
<Routes>
  <Route path="/" element={<Search />} />
  <Route path="/marRes" element={<MarksResult />} />
  
</Routes>
</BrowserRouter>

    </div>
  )
}


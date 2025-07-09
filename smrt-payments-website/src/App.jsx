import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import EmployeeSite from './pages/EmployeeSite';
import KoTeCorner from './pages/KoTeCorner';
import MerchantResources from './pages/MerchantResources';
import BlogNewsroom from './pages/BlogNewsroom';
import { SiteModeContext } from './context/SiteModeContext';

const App = () => {
  const [isEmployeeMode, setIsEmployeeMode] = useState(false);

  return (
    <SiteModeContext.Provider value={{ isEmployeeMode, setIsEmployeeMode }}>
      <Router>
        <div className="min-h-screen">
          <button
            onClick={() => setIsEmployeeMode(!isEmployeeMode)}
            className="fixed top-4 right-4 p-2 bg-smrt-green-600 text-white rounded-full"
          >
            <img src="/cto-signature.png" alt="Toggle Mode" className="w-6 h-6" />
          </button>
          <Routes>
            {isEmployeeMode ? (
              <Route path="/" element={<EmployeeSite />} />
            ) : (
              <>
                <Route path="/" element={<Home />} />
                <Route path="/kote" element={<KoTeCorner />} />
                <Route path="/resources" element={<MerchantResources />} />
                <Route path="/blog" element={<BlogNewsroom />} />
              </>
            )}
          </Routes>
        </div>
      </Router>
    </SiteModeContext.Provider>
  );
};

export default App;

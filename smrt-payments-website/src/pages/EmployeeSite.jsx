import React, { useState, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import Quiz from '../components/Quiz';
import { SiteModeContext } from '../context/SiteModeContext';

const EmployeeSite = () => {
  const { setIsEmployeeMode } = useContext(SiteModeContext);
  const navigate = useNavigate();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const toggleToMerchantMode = () => {
    setIsEmployeeMode(false);
    navigate('/');
  };

  return (
    <div className="bg-smrt-green-50 min-h-screen p-6">
      <header className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-smrt-green-600">SMRT Employee Handbook</h1>
        <button
          onClick={toggleToMerchantMode}
          className="p-2 bg-smrt-green-600 text-white rounded-full"
        >
          <img src="/cto-signature.png" alt="Back to Merchant Site" className="w-6 h-6" />
        </button>
      </header>
      <nav className="mt-4">
        <ul className="flex space-x-4">
          <li><a href="#introduction" className="text-smrt-green-600 hover:underline">Introduction</a></li>
          <li><a href="#policies" className="text-smrt-green-600 hover:underline">Policies</a></li>
          <li><a href="#quizzes" className="text-smrt-green-600 hover:underline">Quizzes</a></li>
        </ul>
      </nav>
      <section className="mt-6">
        <h2 className="text-2xl">Interactive Handbook</h2>
        <p>Welcome to our digital handbook! Complete the quizzes to test your knowledge.</p>
        {isLoading && <p>Loading quizzes...</p>}
        {error && <p className="text-red-600">Error: {error}</p>}
        <Quiz setIsLoading={setIsLoading} setError={setError} />
      </section>
    </div>
  );
};

export default EmployeeSite;

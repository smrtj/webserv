import React from 'react';
import CultureCarousel from '../components/CultureCarousel';
import WelcomeVideo from '../components/WelcomeVideo';

const Home = () => {
  return (
    <div className="bg-smrt-green-100 min-h-screen">
      <header className="p-6 text-center">
        <h1 className="text-4xl font-bold text-smrt-green-600 animate-pulse">
          Welcome to SMRT Payments!
        </h1>
        <p className="mt-4 text-lg">Empowering merchants with smart solutions.</p>
      </header>
      <WelcomeVideo />
      <CultureCarousel />
    </div>
  );
};

export default Home;

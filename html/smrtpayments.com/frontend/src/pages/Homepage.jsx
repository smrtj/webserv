import React from 'react';
import '/var/www/assets/SMRT.css';

const Homepage = () => (
  <div className="homepage">
    <header className="header">
      <h1>Welcome to SMRT Payments!</h1>
      <p>Merchant Minded & SMRT-er Together!</p>
    </header>
    <section className="culture-carousel">
      {["Merchant Minded", "Team First", "Growth Mindset", "Positive Vibes", 
        "Integrity Always", "No Bullies, No Drama, No Fake", 
        "Zero Tolerance for Not Having Fun", "Celebrate Wins"].map((value, index) => (
        <div key={index} className="culture-card">
          {value}
        </div>
      ))}
    </section>
  </div>
);

export default Homepage;

import React, { useState } from 'react';

const coreValues = [
  { id: 1, title: 'Innovation', description: 'Pushing the boundaries of payment tech.' },
  { id: 2, title: 'Trust', description: 'Building reliable solutions for merchants.' },
  { id: 3, title: 'Fun', description: 'Keeping it SMRT and playful!' },
];

const CultureCarousel = () => {
  const [current, setCurrent] = useState(0);

  const nextSlide = () => setCurrent((current + 1) % coreValues.length);
  const prevSlide = () => setCurrent((current - 1 + coreValues.length) % coreValues.length);

  return (
    <div className="relative p-6">
      <div className="flex justify-center items-center">
        <button onClick={prevSlide} className="p-2 text-smrt-green-600">←</button>
        <div className="mx-4 p-4 bg-white rounded-lg shadow-lg transform transition-transform duration-500 hover:scale-105">
          <h2 className="text-2xl font-bold">{coreValues[current].title}</h2>
          <p>{coreValues[current].description}</p>
        </div>
        <button onClick={nextSlide} className="p-2 text-smrt-green-600">→</button>
      </div>
    </div>
  );
};

export default CultureCarousel;

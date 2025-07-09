import React from 'react';

const WelcomeVideo = () => {
  return (
    <div className="p-6">
      <video
        src="/videos/welcome.mp4"
        controls
        className="w-full max-w-2xl mx-auto rounded-lg shadow-lg"
      >
        Welcome to SMRT Payments!
      </video>
    </div>
  );
};

export default WelcomeVideo;

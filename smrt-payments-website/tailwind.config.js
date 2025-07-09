/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        'smrt-green': {
          50: '#f0fdf4',
          100: '#dcfce7',
          600: '#15803d',
        },
      },
    },
  },
  plugins: [],
};

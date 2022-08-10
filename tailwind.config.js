/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
    colors: {
      primary: '#BD4B31',
      secondary: '#F2CDA2',
      // ...
    },
  },
  plugins: [],
};

import React from 'react';

export const SiteModeContext = React.createContext({
  isEmployeeMode: false,
  setIsEmployeeMode: () => {},
});

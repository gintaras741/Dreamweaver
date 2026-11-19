import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

import './design/fonts';
import './design/app.css';

const rootElement = document.getElementById('root');
if (!rootElement) {
  throw new Error('Missing #root element in index.html');
}

createRoot(rootElement).render(
  <StrictMode>
    <main>
      <h1>Dreamweaver</h1>
    </main>
  </StrictMode>,
);

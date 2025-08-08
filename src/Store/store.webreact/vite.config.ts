import { defineConfig } from 'vite';
import plugin from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [plugin()],
    server: {
        port: 64149,
        host: '0.0.0.0',
        proxy: {
            '/api/consumers': 'http://localhost:8081',
            '/api/products': 'http://localhost:8082',
            '/api/cart': 'http://localhost:8083'
        }
    }
})

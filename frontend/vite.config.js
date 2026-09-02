import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

const rawBasePath = process.env.VITE_BASE_PATH || '/'
const normalizedBasePath = rawBasePath.startsWith('/')
  ? rawBasePath
  : `/${rawBasePath}`
const buildBasePath = normalizedBasePath.endsWith('/')
  ? normalizedBasePath
  : `${normalizedBasePath}/`

// Allow the proxy target to be overridden via BACKEND_URL so the Vite dev
// server can reach the API when running inside Docker Compose (where the
// backend is accessible as http://backend:8000, not http://localhost:8000).
const backendUrl = process.env.BACKEND_URL || 'http://localhost:8000'
const backendWsUrl = backendUrl.replace(/^http/, 'ws')

// https://vitejs.dev/config/
export default defineConfig(({ command }) => ({
  plugins: [react()],
  base: command === 'build' ? buildBasePath : '/',
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: backendUrl,
        changeOrigin: true,
      },
      '/ws': {
        target: backendWsUrl,
        ws: true,
      },
    },
  },
}))

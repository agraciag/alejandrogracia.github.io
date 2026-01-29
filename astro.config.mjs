// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import mdx from '@astrojs/mdx';

// https://astro.build/config
export default defineConfig({
  site: 'https://alejandrogracia.com',
  server: {
    host: true,
    port: 4321,
    // allowedHosts funciona tanto para 'dev' como 'preview' en Astro 5.4+
    allowedHosts: [
      'alejandrogracia.com',
      'www.alejandrogracia.com',
      'host.docker.internal',
      'localhost'
    ]
  },
  vite: {
    plugins: [tailwindcss()]
  },
  integrations: [mdx()]
});

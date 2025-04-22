// @ts-check
import elmstronaut from 'elmstronaut';
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
    integrations: [elmstronaut()],
});

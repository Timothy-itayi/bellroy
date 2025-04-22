// @ts-check
import elm from "astro-integration-elm"
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
    integrations: [elm()],
});

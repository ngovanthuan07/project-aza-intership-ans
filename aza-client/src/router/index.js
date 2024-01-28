import { createRouter, createWebHistory } from 'vue-router';
import aza from './aza.js';

const routes = [...aza];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
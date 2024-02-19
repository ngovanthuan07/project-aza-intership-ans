import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import route from './router'
import axios from 'axios'
window.axios = axios

/* import the fontawesome */
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { fas } from '@fortawesome/free-solid-svg-icons'

library.add(fas)

/* import the bootstrap */
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import 'bootstrap/dist/css/bootstrap-grid.min.css';
import 'bootstrap/dist/css/bootstrap-utilities.min.css';

import store from './store'
import VueTheMask from 'vue-the-mask'

const app = createApp(App)
app.use(route)
app.use(store)
app.use(VueTheMask)
app.component('font-awesome-icon', FontAwesomeIcon)
app.mount('#app')

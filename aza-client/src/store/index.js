import { createStore } from 'vuex'
import Pagination from './pagination/pagination.module'
export default createStore({
    modules: {
        pagination: Pagination
    }
})
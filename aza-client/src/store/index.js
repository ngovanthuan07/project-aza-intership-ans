import { createStore } from 'vuex'
import dataTable from "./modules/data-table/index.js";
import formDataSearch from "./modules/delivery-search/search-from/index.js"
import dataSearch from "./modules/delivery-search/data-search/index.js"
export default createStore({
    modules: {
        dataTable,
        formDataSearch,
        dataSearch
    }
})
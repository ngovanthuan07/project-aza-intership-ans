import { createStore } from 'vuex'
import dataTable from "./modules/data-table/index.js";
import formDataSearch from "./modules/delivery-search/search-from/index.js"
import loadingSpinner from "./modules/loading-spinner/index.js";
import requestForm from "./modules/request-form/index.js";
export default createStore({
    modules: {
        dataTable,
        formDataSearch,
        requestForm,
        loadingSpinner
    }
})
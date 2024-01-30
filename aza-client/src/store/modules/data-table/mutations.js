import {
    CURRENT_PAGE,
    MU_UPDATE_DATATABLES, PAGE_SIZE, SORT_COLUMN, SORT_ORDER, SORT_ORDERS, START_PAGE, TABLES, TOTAL_ITEMS, TOTAL_PAGES
} from "./types.js";

export default {
    [MU_UPDATE_DATATABLES] (state, action) {
        const type = action.type;
        const payload = action.payload;
        switch (type) {
            case SORT_ORDER:
                state.sortOrder = payload
                break;
            case SORT_ORDERS:
                state.sortOrders = payload
                break;
            case SORT_COLUMN:
                state.sortColumn = payload
                break;
            case PAGE_SIZE:
                state.pageSize = payload
                break;
            case CURRENT_PAGE:
                state.currentPage = payload
                break;
            case TOTAL_ITEMS:
                state.totalItems = payload
                break;
            case TOTAL_PAGES:
                state.totalPages = payload
                break;
            case START_PAGE:
                state.statPage = payload
                break;
            case TABLES:
                state.tables = payload
        }
    }
}
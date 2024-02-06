import {
    GET_CURRENT_PAGE, GET_PAGE_HIDDEN,
    GET_PAGE_SIZE, GET_SORT_COLUMN,
    GET_SORT_ORDER,
    GET_SORT_ORDERS,
    GET_START_PAGE,
    GET_TOTAL_ITEMS,
    GET_TOTAL_PAGES
} from "./types.js";

export default {
    [GET_SORT_ORDER]: (state) => state.sortOrder,
    [GET_SORT_ORDERS]: (state) => state.sortOrders,
    [GET_SORT_COLUMN]: (state) => state.sortColumn,
    [GET_PAGE_SIZE]: (state) => state.pageSize,
    [GET_CURRENT_PAGE]: (state) => state.currentPage,
    [GET_TOTAL_ITEMS]: (state) => state.totalItems,
    [GET_TOTAL_PAGES]: (state) => state.totalPages,
    [GET_START_PAGE]: (state) => state.startPage,
    [GET_PAGE_HIDDEN]: (state) => state.showPageHidden,
}
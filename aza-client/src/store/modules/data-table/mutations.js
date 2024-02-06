import {
    CURRENT_PAGE,
    LIST_DATA,
    MU_UPDATE_DATATABLES,
    PAGE_SIZE, RESET_STATE,
    SORT_COLUMN,
    SORT_ORDER,
    SORT_ORDERS,
    START_PAGE,
    TEST_UPDATE_DATATABLES,
    TOTAL_ITEMS,
    TOTAL_PAGES, UPDATE_STATE
} from "./types.js";

export default {
    [MU_UPDATE_DATATABLES] (state, action) {
        const type = action.type;
        const payload = action.payload;
        switch (type) {
            case UPDATE_STATE:
                console.log(payload)
                Object.assign(state, payload);
                break;
            case RESET_STATE:
                Object.assign(state, {
                    sortOrder: 'ASC',
                    sortOrders: [],
                    sortColumn: null,
                    pageSize: 10,
                    currentPage: 1,
                    totalItems: 0,
                    totalPages: 0,
                    startPage: 1,
                    listData: []
                });
        }
    },

}


import {
    CURRENT_PAGE,
    LIST_DATA,
    MU_UPDATE_DATATABLES,
    PAGE_SIZE,
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
                Object.assign(state, payload);
                break;
        }
    },

}
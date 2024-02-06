import {
    AC_CHANGE_DATATABLES, MU_UPDATE_DATATABLES
} from "./types.js";

export default {
    [AC_CHANGE_DATATABLES](context, action) {
        const type = action.type;
        const payload = action.payload;
        console.log('ACTION: ', action)
        switch (type) {
            default:
                context.commit(MU_UPDATE_DATATABLES, action)
        }
    },
}
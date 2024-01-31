import {
    AC_CHANGE_DATATABLES, AC_CHANGE_MULTIPLE_DATATABLES, MU_UPDATE_DATATABLES

} from "./types.js";

export default {
    [AC_CHANGE_DATATABLES](context, action) {
        const type = action.type;
        const payload = action.payload;
        switch (type) {
            default:
                context.commit(MU_UPDATE_DATATABLES, action)
        }
    },

     [AC_CHANGE_MULTIPLE_DATATABLES](context, actions) {
        for(let action of actions) {
            context.commit(MU_UPDATE_DATATABLES, action)
       }
    }
}
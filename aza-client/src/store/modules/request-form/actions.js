import {
    CHANGE_OPTION,
    SET_FORM_DATA_DETAIL_M,
    UPDATE_FORM_DATA_DETAIL_A

} from "./types.js";

export default {
    [UPDATE_FORM_DATA_DETAIL_A]({ commit }, action) {
        let type = action.type;
        let payload = action.payload

        switch (type) {
            case CHANGE_OPTION: {
                commit(CHANGE_OPTION, payload)
                break;
            }
            default: {
                commit(SET_FORM_DATA_DETAIL_M, payload)
            }
        }
    },
}
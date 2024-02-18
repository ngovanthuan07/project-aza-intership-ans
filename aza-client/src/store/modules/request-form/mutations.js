import {
    CHANGE_OPTION,
    SET_FORM_DATA_DETAIL_M

} from "./types.js";

export default {
    [SET_FORM_DATA_DETAIL_M](state, payload) {
        state.deliveryDetail.formData = { ...state.deliveryDetail.formData, ...payload };
    },
    [CHANGE_OPTION](state, payload) {
        state.deliveryDetail.option = payload
    }
}
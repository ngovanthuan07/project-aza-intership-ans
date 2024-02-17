import {
    SET_FORM_DATA_DETAIL_M

} from "./types.js";

export default {
    [SET_FORM_DATA_DETAIL_M](state, payload) {
        state.deliveryDetail.formData = { ...state.deliveryDetail.formData, ...payload };
    },
}
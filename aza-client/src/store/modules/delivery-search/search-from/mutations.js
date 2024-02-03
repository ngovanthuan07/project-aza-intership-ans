import {
    RESET_FORM_DATA,
    SET_FORM_DATA

} from "./types.js";

export default {
    [SET_FORM_DATA](state, payload) {
        state.formData = { ...state.formData, ...payload };
    },
    [RESET_FORM_DATA](state) {
        state.formData = {
            delivery_cd: null,
            delivery_nm: null,
            delivery_kn: null,
            address: null,
            tel: null,
            delivery_class_1: null,
            delivery_class_2: null,
            delivery_class_3: null,
        }
    }
}
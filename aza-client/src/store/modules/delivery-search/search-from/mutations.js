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
            delivery_cd: '',
            delivery_nm: '',
            delivery_kn: '',
            address: '',
            tel: '',
            delivery_class_1: 0,
            delivery_class_2: 0,
            delivery_class_3: 0,
        }
    }
}
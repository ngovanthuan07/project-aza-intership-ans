import {
    ON_RESET_FORM_DATA,
    RESET_FORM_DATA, SET_FORM_DATA, UPDATE_FORM_DATA

} from "./types.js";

export default {
    [UPDATE_FORM_DATA]({ commit }, payload) {
        commit(SET_FORM_DATA, payload);
    },
    [ON_RESET_FORM_DATA]({ commit }) {
        commit(RESET_FORM_DATA);
    }

}
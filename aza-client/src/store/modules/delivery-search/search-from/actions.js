import {
    ON_RESET_FORM_DATA,
    RESET_FORM_DATA, SET_FORM_DATA, UPDATE_FORM_DATA

} from "./types.js";

export default {
    [UPDATE_FORM_DATA]({ commit }, action) {
        const type = action.type;
        let payload = action.payload
        switch (type) {

        }
        commit(SET_FORM_DATA, action);
    },
    [ON_RESET_FORM_DATA]({ commit }) {
        commit(RESET_FORM_DATA);
    }
}
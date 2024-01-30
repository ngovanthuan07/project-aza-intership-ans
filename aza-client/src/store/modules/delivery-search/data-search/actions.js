import {
    SET_DATA,
    UPDATE_DATA

} from "./types.js";

export default {
    [UPDATE_DATA]({ commit }, payload) {
        commit(SET_DATA, payload);
    },

}
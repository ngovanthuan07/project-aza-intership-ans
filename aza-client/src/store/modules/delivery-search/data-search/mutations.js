import {
    SET_DATA
} from "./types.js";

export default {
    [SET_DATA](state, payload) {
        state.datas = payload;
    },
}
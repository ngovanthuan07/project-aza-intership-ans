import {
    SHOW_LOADING_A, SHOW_LOADING_M

} from "./types.js";

export default {
    [SHOW_LOADING_A]({ commit }, payload) {
        commit(SHOW_LOADING_M, payload)
    }
}
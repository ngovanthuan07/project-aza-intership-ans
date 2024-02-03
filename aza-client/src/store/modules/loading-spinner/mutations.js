import {
    SHOW_LOADING_M
} from "./types.js";

export default {
    [SHOW_LOADING_M](state, payload) {
        state.showLoading = payload;
    }
}
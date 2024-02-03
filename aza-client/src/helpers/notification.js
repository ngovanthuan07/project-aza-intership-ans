import {toast} from "vue3-toastify";
import 'vue3-toastify/dist/index.css';


export function notificationError(content) {
    toast.error(content, {
        autoClose: 1500
    })
}
export function notificationSuccess(content) {
    toast.error(content, {
        autoClose: 1500
    })
}
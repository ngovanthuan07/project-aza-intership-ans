import {postData} from "./HandleAPI.js";

export default async function loadDelivery(delivery_cd) {
    try {
        let result = await postData(import.meta.env.VITE_APP_API_GET_DELIVERY_BY_CD, {delivery_cd});
        if (result?.delivery) {
            return result.delivery
        }
    } catch (e) {
        console.error(e)
        return null;
    }
    return null
}
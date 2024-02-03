import axios from "axios";

export let postData = async function(url, data) {
    try {
        let response = await axios.post(url, data);
        console.warn('RESPONSE 👌', response)
        return response?.data;
    } catch (error) {
        console.error('An error occurred:', error);
        return null;
    }
}

export let getData = async function(url, data) {
    try {
        let response = await axios.get(url, data);
        console.warn('RESPONSE 👌', response)
        return response?.data;
    } catch (error) {
        console.error('An error occurred:', error);
        return null;
    }
}
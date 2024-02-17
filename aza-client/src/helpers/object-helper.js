export function mergeObject(o1, o2) {
    for (let key in o2) {
        if (o1.hasOwnProperty(key)) {
            o1[key] = o2[key];
        }
    }
    return o1;
}

function hasNonNullValue(obj) {
    return Object.values(obj).some(val => val !== null && val !== undefined && val !== 0 && val !== '' && val?.length !== 0);
}


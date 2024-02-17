function setLocalStorage(key, value) {
    localStorage.setItem(key, JSON.stringify(value));
}

function getLocalStorage(key) {
    const storedValue = localStorage.getItem(key);
    return storedValue ? JSON.parse(storedValue) : null;
}

function removeLocalStorage(key) {
    localStorage.removeItem(key);
}

function clearLocalStorage() {
    localStorage.clear();
}

export const EMPTY = 'empty'
export const REQUIRED = 'required'


export function ValidateFormData(options) {
    let errors = {};
    let {formData, messages} = options
    let isError = false;

    for(let [attribute, rules] of Object.entries(options.rules)) {
        if(rules.includes(EMPTY) && (formData[attribute] === null || formData[attribute] === undefined || formData[attribute].length === 0)){
            errors[attribute] = []
            continue;
        }
        for(let rule of rules) {
            let ruleName, ruleValue;
            if (typeof rule === 'string') {
                [ruleName, ruleValue] = rule.includes(':') ? rule.split(':') : [rule, null];
            } else if (Array.isArray(rule)) {
                [ruleName, ruleValue] = rule;
                if (typeof ruleValue === 'function') {
                    ruleValue = ruleValue();
                }
            }

            if (typeof validationRules[ruleName] !== 'function') continue;
            if(formData[attribute] === null)
                formData[attribute] = ''
            const isValid = validationRules[ruleName](formData[attribute], ruleValue);

            if (isValid) {
                const message = messages[attribute][ruleName];
                errors[attribute] ? errors[attribute].push(message) : errors[attribute] = [message];
                isError = true;
            }
        }
    }
    return [errors, isError]
}

export function ValidateField(options) {
    let {value, rules, messages} = options
    const errorMessageInput = [];

    if(rules.includes(EMPTY) && (value === null || value === undefined || value.length === 0))
        return [];

    for (const rule of rules) {
        let ruleName, ruleValue;
        if (typeof rule === 'string') {
            [ruleName, ruleValue] = rule.includes(':') ? rule.split(':') : [rule, null];
        } else if (Array.isArray(rule)) {
            [ruleName, ruleValue] = rule;
            if (typeof ruleValue === 'function') {
                ruleValue = ruleValue();
            }
        }
        if (typeof validationRules[ruleName] !== 'function') continue;

        const isValid = validationRules[ruleName](value, ruleValue);

        if (isValid) {
            const message = messages[ruleName];
            errorMessageInput.push(message);
        }
    }
    return errorMessageInput;
}

export const validationRules = {
    required: function (value) {
        return value === null || value === '' || value === [] ? true : false;
    },
    min: function (value, min) {
        return value.length < min ? true : false;
    },
    max: function (value, max) {
        return value.length > max ? true : false;
    },
    email: function (value) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(value);
    },
    numeric: function (value) {
        return !isNaN(value);
    },
    len: function (value , len) {
        return Number(value.length) !== Number(len) ? true : false;
    },
    zip: function (value , pattern) {
        return !pattern.test(value)
    },
    katakana: function (value) {
        const katakanaRegex = /^([ァ-ン]|ー)+$/;
        return !katakanaRegex.test(value);
    },
    byte: function (value, byteLimit) {
        if (typeof value === 'string') {
            let encoder = new TextEncoder();
            let byteArray = encoder.encode(value);
            return byteArray.byteLength >= byteLimit;
        } else if (typeof value === 'number' && Number.isInteger(value)) {
            return Int32Array.BYTES_PER_ELEMENT >= byteLimit;
        } else if (Array.isArray(value) && value.every(item => typeof item === 'number')) {
            return (value.length * Float64Array.BYTES_PER_ELEMENT) >= byteLimit;
        } else {
            console.error("Không hỗ trợ kiểm tra số byte cho kiểu dữ liệu này");
            return false;
        }
    },
    japanPhone: function (value) {
        let phoneRegex = /^(0([1-9]{1}-?[1-9]\d{3}|[1-9]{2}-?\d{3}|[1-9]{2}\d{1}-?\d{2}|[1-9]{2}\d{2}-?\d{1})-?\d{4}|0[789]0-?\d{4}-?\d{4}|050-?\d{4}-?\d{4})$/;
        return !phoneRegex.test(value)
    },
    japanFax: function (value) {
        let faxRegex = /^0\d{1,4}-\d{1,4}-\d{4}$/;
        return !faxRegex.test(value);
    }
}




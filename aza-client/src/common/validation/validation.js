export function ValidateFormData(options) {
    let errors = {};
    let {formData, messages} = options

    for(let [attribute, rules] of Object.entries(options.rules)) {
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
            const isValid = validationRules[ruleName](formData[attribute], ruleValue);

            if (isValid) {
                const message = messages[attribute][ruleName];
                errors[attribute] ? errors[attribute].push(message) : errors[attribute] = [message];
            }
        }
    }
    return errors
}

export function ValidateField(options) {
    let {value, rules, messages} = options
    const errorMessageInput = [];
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
        return value.length <= min ? true : false;
    },
    max: function (value, max) {
        return value.length >= max ? true : false;
    },
    email: function (value) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(value);
    },
    numeric: function (value) {
        return !isNaN(value);
    },
}




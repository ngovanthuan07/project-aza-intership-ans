export const rules = {
    'delivery_nm1': [
        'required',
        'max:50',
    ],
    'delivery_nm2': [
        'required',
        'max:40',
    ],
    'delivery_kn1': [
        'required',
        'max:80',
        'katakana'
    ],
    'delivery_kn2': [
        'required',
        'max:80',
        'katakana'
    ],
    'zip_cd': [
        'empty',
        'len:8',
        ['zip', /^\d{3}-\d{4}$/]
    ],
    'tel': [
        'empty',
        'max:13',
        'japanPhone'
    ],
    'fax': [
        'empty',
        'max:12',
        'japanFax'
    ]
}

export const messages  = {
    'delivery_nm1': {
        'required': '空白のままにすることはできません',
        'max'     : '限界、限界 50',
    },
    'delivery_nm2': {
        'required': '空白のままにすることはできません',
        'max'     : '限界、限界 40',
    },
    'delivery_kn1': {
        'required': '空白のままにすることはできません',
        'max'     : '限界、限界 80',
        'katakana': 'カタカナ文字'
    },
    'delivery_kn2': {
        'required': '空白のままにすることはできません',
        'max': '限界、限界 80',
        'katakana': 'カタカナ文字'
    },
    'zip_cd': {
        'len': '限界、限界 8',
        'zip': '図 135-0061, 135-8625',
    },
    'tel': {
        'max': '限界、限界 13',
        'japanPhone': '図 03-5500-5500, 090-7196-1361',
    },
    'fax': {
        'max': '限界、限界 12',
        'japanFax': '図 03-5500-25251, 080-1234-5678',
    }
}
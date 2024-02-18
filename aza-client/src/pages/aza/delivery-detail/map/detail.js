import {mergeObject} from "../../../../helpers/object-helper.js";

export function mapAddDetail (data) {
    let map = {
             delivery_nm1                :  null
        ,    delivery_kn1                :  null
        ,    delivery_nm2                :  null
        ,    delivery_kn2                :  null
        ,    zip_cd                      :  null
        ,    prefecture_cd               :  null
        ,    city_nm                     :  null
        ,    town_nm                     :  null
        ,    apartment_nm                :  null
        ,    address1                    :  null
        ,    address2                    :  null
        ,    tel                         :  null
        ,    fax                         :  null
        ,    delivery_class_1            :  null
        ,    delivery_class_2            :  null
        ,    delivery_class_3            :  null
        ,    remark                      :  null
        ,    cre_user                    :  null
        ,    cre_prg                     :  null
        ,    cre_ip                      :  null
        ,    cre_date                    :  null
    }
    return mergeObject(map, data);
}

export function mapUpdateDetail (data) {
    let map = {
             delivery_cd                 :  null
        ,    delivery_nm1                :  null
        ,    delivery_kn1                :  null
        ,    delivery_nm2                :  null
        ,    delivery_kn2                :  null
        ,    zip_cd                      :  null
        ,    prefecture_cd               :  null
        ,    city_nm                     :  null
        ,    town_nm                     :  null
        ,    apartment_nm                :  null
        ,    address1                    :  null
        ,    address2                    :  null
        ,    tel                         :  null
        ,    fax                         :  null
        ,    delivery_class_1            :  null
        ,    delivery_class_2            :  null
        ,    delivery_class_3            :  null
        ,    remark                      :  null
        ,    upd_user                    :  null
        ,    upd_prg                     :  null
        ,    upd_ip                      :  null
        ,    upd_date                    :  null
    }
    return mergeObject(map, data);
}

export function resetData(data) {
    let map = {
             delivery_cd                 :  null
        ,    delivery_nm1                :  null
        ,    delivery_kn1                :  null
        ,    delivery_nm2                :  null
        ,    delivery_kn2                :  null
        ,    zip_cd                      :  null
        ,    prefecture_cd               :  null
        ,    city_nm                     :  null
        ,    town_nm                     :  null
        ,    apartment_nm                :  null
        ,    address1                    :  null
        ,    address2                    :  null
        ,    tel                         :  null
        ,    fax                         :  null
        ,    delivery_class_1            :  null
        ,    delivery_class_2            :  null
        ,    delivery_class_3            :  null
        ,    remark                      :  null
        ,    cre_user                    :  null
        ,    cre_prg                     :  null
        ,    cre_ip                      :  null
        ,    cre_date                    :  null
        ,    upd_user                    :  null
        ,    upd_prg                     :  null
        ,    upd_ip                      :  null
        ,    upd_date                    :  null
        ,    del_date                    :  null
        ,    del_flg                     :  null
        ,    del_ip                      :  null
        ,    del_prg                     :  null
        ,    del_user                    :  null
        ,    sch_delivery_nm             :  null
        ,    memo                        :  null
    }
    return mergeObject(map, data);
}


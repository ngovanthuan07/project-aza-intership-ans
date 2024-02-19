<script>
import {createNamespacedHelpers} from "vuex";
import {getData} from "../service/HandleAPI.js";
import PopupSearch from "../popup/table-search/PopupSearch.vue";
import {CHANGE_ERROR_MESSAGE, UPDATE_FORM_DATA_DETAIL_A} from "../../../../store/modules/request-form/types.js";
import {AC_CHANGE_DATATABLES, RESET_STATE} from "../../../../store/modules/data-table/types.js";
import {ON_RESET_FORM_DATA} from "../../../../store/modules/delivery-search/search-from/types.js";
import {SHOW_LOADING_A} from "../../../../store/modules/loading-spinner/types.js";
import {ValidateField} from "../../../../common/validation/validation.js";
import {rules, messages} from "../request/formDetailRequest.js";
const {
  mapState: mapDatableState,
  mapActions: mapDatatableActions
} = createNamespacedHelpers('dataTable');
const {
  mapState: mapFormDataSearchState,
  mapActions: mapFormDataSearchActions
} = createNamespacedHelpers('formDataSearch');

const {
  mapState: mapLoadingState,
  mapActions: mapLoadingActions
} = createNamespacedHelpers('loadingSpinner');
const {
  mapState: mapFormDataDetailState,
  mapActions: mapFormDataDetailActions
} = createNamespacedHelpers('requestForm');



export default {
  components: {PopupSearch},
  props: {
    handleOpenPopUp: Function
  },
  methods: {
    ...mapFormDataDetailActions([
      UPDATE_FORM_DATA_DETAIL_A
    ]),
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    ...mapFormDataSearchActions([
      ON_RESET_FORM_DATA
    ]),
    ...mapLoadingActions([
      SHOW_LOADING_A
    ]),
    async getDeliveryClasses() {
      let sLibVal = await getData(import.meta.env.VITE_APP_DELIVERY_CLASS);
      this.deliveryClassOne = sLibVal.deliveryClassOne;
      this.deliveryClassTwo = sLibVal.deliveryClassTwo;
      this.deliveryClassThree = sLibVal.deliveryClassThree;
      this.prefectures = sLibVal.prefectures
    },
    async onSearchPopup() {
      this[SHOW_LOADING_A](true)
      await this.handleOpenPopUp()
      setTimeout(() => {
        this[SHOW_LOADING_A](false);
      }, 200);
    },
    // start valid
    handleBlur(fieldName, init = '') {

      this.errors[fieldName] = ValidateField({
        'value': this.formData[fieldName] ? this.formData[fieldName] : init,
        'rules': rules[fieldName],
        'messages': messages[fieldName]
      })
    },
    hasError(fieldName) {
      return !this.errors[fieldName] ?  false : (
          !(this.errors[fieldName].length > 0) ? false : true
      );
    },
    getFirstError(fieldName) {
      return this.errors[fieldName][0]
    },
    // end valid
  },
  computed: {
    ...mapFormDataDetailState({
      formData: state => state.deliveryDetail.formData,
      errors:   state => state.deliveryDetail.errorsMessages
    })
  },
  mounted () {
    this.getDeliveryClasses();

  },
  data() {
    return {
      deliveryClassOne: [],
      deliveryClassTwo: [],
      deliveryClassThree: [],
      prefectures: [],
    };
  },
}
</script>

<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-2">
        <div class="form-group">
          <label for="searchInput" class="form-label">納入先コード</label>
          <div class="input-group">
            <input type="text"
                   v-model="formData.delivery_cd"
                   class="form-control"
                   maxlength="6"
                   data-maxlength="6"
                   tabindex="11"
                   disabled
                   id="searchInput"
                   aria-label="Search"
                   aria-describedby="searchIcon" />
            <button class="input-group-text bg-transparent btn-search"
                    @click="onSearchPopup"
                    id="searchIcon" tabindex="12">
              <font-awesome-icon :icon="['fas', 'magnifying-glass']"
                                 class="input-icon" />
            </button>
          </div>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput1"
                 class="form-label">納入先名1</label>
          <input type="text" class="form-control"
                 maxlength="50"
                 v-model="formData.delivery_nm1"
                 @blur="handleBlur('delivery_nm1')"
                 :class="{'is-validate' : hasError('delivery_nm1') === true }"
                 id="normalInput1"
                 tabindex="13"/>
          <div v-if="hasError('delivery_nm1')" class="error-message">
            {{getFirstError('delivery_nm1')}}
          </div>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">納入先名2</label>
          <input type="text"
                 maxlength="40"
                 v-model="formData.delivery_nm2"
                 @blur="handleBlur('delivery_nm2')"
                 class="form-control"
                 :class="{'is-validate' : hasError('delivery_nm2') === true }"
                 id="normalInput2"
                 tabindex="14"/>
          <div v-if="hasError('delivery_nm2')" class="error-message">
            {{getFirstError('delivery_nm2')}}
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-3">
        <div class="form-group">
          <label for="normalInput1" class="form-label">フリガナ1</label>
          <input type="text"
                 v-model="formData.delivery_kn1"
                 @blur="handleBlur('delivery_kn1')"
                 :class="{'is-validate' : hasError('delivery_kn1') === true }"
                 class="form-control"
                 maxlength="80"
                 id="normalInput1"
                 tabindex="15"/>
          <div v-if="hasError('delivery_kn1')" class="error-message">
            {{getFirstError('delivery_kn1')}}
          </div>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">フリガナ2</label>
          <input type="text"
                 v-model="formData.delivery_kn2"
                 @blur="handleBlur('delivery_kn2')"
                 :class="{'is-validate' : hasError('delivery_kn2') === true }"
                 maxlength="80"
                 class="form-control"
                 id="normalInput2"
                 tabindex="16"/>
          <div v-if="hasError('delivery_kn2')" class="error-message">
            {{getFirstError('delivery_kn2')}}
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-2">
        <div class="form-group">
          <label for="normalInput2" class="form-label">郵便番号</label>
          <input type="text"
                 class="form-control"
                 v-model="formData.zip_cd"
                 @blur="handleBlur('zip_cd')"
                 :class="{'is-validate' : hasError('zip_cd') === true }"
                 maxlength="8"
                 v-mask="'###-####'"
                 id="normalInput2"
                 tabindex="17"/>
          <div v-if="hasError('zip_cd')" class="error-message">
            {{getFirstError('zip_cd')}}
          </div>
        </div>
      </div>

      <div class="col-2">
        <div class="form-group">
          <label for="selectInputPrefectures" class="form-label">都道府県</label>
          <select v-model="formData.prefecture_cd" class="form-select form-control" id="selectInputPrefectures" tabindex="18">
            <option value=""></option>
            <option v-for="prefecture in prefectures" :value="prefecture.lib_val_cd">
              {{ prefecture.lib_val_nm }}
            </option>
          </select>
        </div>
      </div>

      <div class="col-4">
        <div class="form-group">
          <label for="normalInput1" class="form-label">市区町村</label>
          <input type="text"
                 v-model="formData.city_nm"
                 class="form-control"
                 maxlength="12"
                 id="normalInput1"  tabindex="19"/>
        </div>
      </div>

      <div class="col-4">
        <div class="form-group">
          <label for="normalInput2" class="form-label">町・番地</label>
          <input type="text"
                 class="form-control"
                 v-model="formData.town_nm"
                 maxlength="18"
                 id="normalInput2"
                 tabindex="20"/>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-4">
        <div class="form-group">
          <label for="normalInput2" class="form-label">マンション・ビル名</label>
          <input type="text"
                 maxlength="18"
                 class="form-control"
                 v-model="formData.apartment_nm"
                 id="normalInput2"
                 tabindex="21"/>
        </div>
      </div>
      <div class="col-4">
        <div class="form-group">
          <label for="normalInput2" class="form-label">住所１</label>
          <input type="text"
                 maxlength="200"
                 v-model="formData.address1"
                 class="form-control"
                 id="normalInput2" />
        </div>
      </div>
      <div class="col-4">
        <div class="form-group">
          <label for="normalInput2" class="form-label">住所２</label>
          <input type="text"
                 maxlength="200"
                 v-model="formData.address2"
                 class="form-control"
                 id="normalInput2" />
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">電話番号</label>
          <input type="text"
                 maxlength="20"
                 class="form-control"
                 v-model="formData.tel"
                 @blur="handleBlur('tel')"
                 v-mask="['###-####-####', '##-####-####']"
                 :class="{'is-validate' : hasError('tel') === true }"
                 id="normalInput2"
                 tabindex="22"/>
          <div v-if="hasError('tel')" class="error-message">
            {{getFirstError('tel')}}
          </div>
        </div>
      </div>
      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">FAX番号</label>
          <input type="text"
                 maxlength="20"
                 class="form-control"
                 v-model="formData.fax"
                 v-mask="'##-####-####'"
                 @blur="handleBlur('fax')"
                 :class="{'is-validate' : hasError('fax') === true }"
                 id="normalInput2"
                 tabindex="23"/>
          <div v-if="hasError('fax')" class="error-message">
            {{getFirstError('fax')}}
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <!-- Input 1 -->
      <div class="col-2">
        <div class="form-group">
          <label for="selectInputDeliveryClassOne" class="form-label">納入先分類1</label>
          <select v-model="formData.delivery_class_1" class="form-select form-control" id="selectInputDeliveryClassOne" tabindex="24">
            <option value=""></option>
            <option v-for="dc in deliveryClassOne" :value="dc.lib_val_cd">
              {{ dc.lib_val_nm }}
            </option>
          </select>
        </div>
      </div>

      <!-- Input 2 -->
      <div class="col-2">
        <div class="form-group">
          <label for="selectInput2" class="form-label">納入先分類2</label>
          <select v-model="formData.delivery_class_2" class="form-select form-control" id="selectInput2" tabindex="25">
            <option value=""></option>
            <option v-for="dc in deliveryClassTwo" :value="dc.lib_val_cd">
              {{ dc.lib_val_nm }}
            </option>
          </select>
        </div>
      </div>

      <!-- Input 3 -->
      <div class="col-2">
        <div class="form-group">
          <label for="selectInput3" class="form-label">納入先分類3</label>
          <select v-model="formData.delivery_class_3" class="form-select form-control" id="selectInput2" tabindex="26">
            <option value=""></option>
            <option v-for="dc in deliveryClassThree" :value="dc.lib_val_cd">
              {{ dc.lib_val_nm }}
            </option>
          </select>
        </div>
      </div>
    </div>


    <div class="row">
      <div class="col-6">
        <div class="form-group">
          <label for="textareaInput" class="form-label" >備考</label>
          <textarea class="form-control"
                    id="textareaInput"
                    v-model="formData.remark"
                    rows="5"
                    maxlength="200"
                    tabindex="27"
                    data-maxlength="200"
          ></textarea>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
@import "./css/css.css";
@import "./css/valid.css";
</style>
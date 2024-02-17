<script>
import {createNamespacedHelpers} from "vuex";
import {getData} from "../service/HandleAPI.js";
import PopupSearch from "../popup/table-search/PopupSearch.vue";
import {UPDATE_FORM_DATA_DETAIL_A} from "../../../../store/modules/request-form/types.js";
import {AC_CHANGE_DATATABLES, RESET_STATE} from "../../../../store/modules/data-table/types.js";
import {ON_RESET_FORM_DATA} from "../../../../store/modules/delivery-search/search-from/types.js";
import {SHOW_LOADING_A} from "../../../../store/modules/loading-spinner/types.js";
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
      this[ON_RESET_FORM_DATA]()
      this[AC_CHANGE_DATATABLES]({type: RESET_STATE, payload: null})
      this[SHOW_LOADING_A](false)
    }
  },
  computed: {
    ...mapFormDataDetailState({
      formData: state => state.deliveryDetail.formData
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
      prefectures: []
    };
  },
}
</script>

<template>
  <PopupSearch />
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
                   id="searchInput"
                   aria-label="Search"
                   aria-describedby="searchIcon" />
            <button class="input-group-text bg-transparent btn-search"
                    @click="onSearchPopup"
                    data-bs-toggle="modal" data-bs-target="#searchModal"
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
                 id="normalInput1"
                 tabindex="13"/>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">納入先名2</label>
          <input type="text"
                 maxlength="40"
                 v-model="formData.delivery_nm2"
                 class="form-control"
                 id="normalInput2"
                 tabindex="14"/>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-3">
        <div class="form-group">
          <label for="normalInput1" class="form-label">フリガナ1</label>
          <input type="text"
                 v-model="formData.delivery_kn1"
                 class="form-control"
                 maxlength="80"
                 id="normalInput1"
                 tabindex="15"/>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">フリガナ2</label>
          <input type="text"
                 v-model="formData.delivery_kn2"
                 maxlength="80"
                 class="form-control"
                 id="normalInput2"
                 tabindex="16"/>
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
                 maxlength="8"
                 id="normalInput2"
                 tabindex="17"/>
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
                 id="normalInput2"
                 tabindex="22"/>
        </div>
      </div>
      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">FAX番号</label>
          <input type="text"
                 maxlength="20"
                 class="form-control"
                 v-model="formData.fax"
                 id="normalInput2"
                 tabindex="23"/>
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
</style>
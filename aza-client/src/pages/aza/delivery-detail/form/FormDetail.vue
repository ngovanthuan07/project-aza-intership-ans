<script>
import {createNamespacedHelpers} from "vuex";
import {
  ON_RESET_FORM_DATA,
  UPDATE_FORM_DATA
} from "../../../../store/modules/delivery-search/search-from/types.js";
import {getData} from "../service/HandleAPI.js";

const {
  mapState: mapFormDataSearchState,
  mapActions: mapFormDataSearchActions
} = createNamespacedHelpers('formDataSearch');

export default {
  methods: {
    ...mapFormDataSearchActions([
      UPDATE_FORM_DATA, ON_RESET_FORM_DATA
    ]),
    async getDeliveryClasses() {
      let sLibVal = await getData(import.meta.env.VITE_APP_DELIVERY_CLASS);
      this.deliveryClassOne = sLibVal.deliveryClassOne;
      this.deliveryClassTwo = sLibVal.deliveryClassTwo;
      this.deliveryClassThree = sLibVal.deliveryClassThree;
      this.prefectures = sLibVal.prefectures
    }
  },
  computed: {
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),

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
  <div class="container-fluid">
    <div class="row">
      <div class="col-2">
        <div class="form-group">
          <label for="searchInput" class="form-label">納入先コード</label>
          <div class="input-group">
            <input type="text"
                   class="form-control"
                   maxlength="6"
                   data-maxlength="6"
                   tabindex="11"
                   id="searchInput"
                   aria-label="Search"
                   aria-describedby="searchIcon" />
            <span class="input-group-text bg-transparent" id="searchIcon" tabindex="12">
              <font-awesome-icon :icon="['fas', 'magnifying-glass']" style="font-size: 13px;" />
            </span>
          </div>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput1"
                 class="form-label">納入先名1</label>
          <input type="text" class="form-control"
                 maxlength="50"
                 id="normalInput1"
                 tabindex="13"/>
        </div>
      </div>

      <div class="col-3">
        <div class="form-group">
          <label for="normalInput2" class="form-label">納入先名2</label>
          <input type="text"
                 maxlength="40"
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
                 maxlength="8"
                 id="normalInput2"
                 tabindex="17"/>
        </div>
      </div>

      <div class="col-2">
        <div class="form-group">
          <label for="selectInputPrefectures" class="form-label">都道府県</label>
          <select class="form-select form-control" id="selectInputPrefectures" tabindex="18">
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
                 id="normalInput2"
                 tabindex="21"/>
        </div>
      </div>
      <div class="col-4">
        <div class="form-group">
          <label for="normalInput2" class="form-label">住所１</label>
          <input type="text"
                 maxlength="200"
                 class="form-control"
                 id="normalInput2" />
        </div>
      </div>
      <div class="col-4">
        <div class="form-group">
          <label for="normalInput2" class="form-label">住所２</label>
          <input type="text"
                 maxlength="200"
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
          <select class="form-select form-control" id="selectInputDeliveryClassOne" tabindex="24">
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
          <select class="form-select form-control" id="selectInput2" tabindex="25">
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
          <select class="form-select form-control" id="selectInput2" tabindex="26">
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
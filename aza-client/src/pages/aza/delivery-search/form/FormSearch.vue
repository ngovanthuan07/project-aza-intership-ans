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
      let deliveryClasses = await getData(import.meta.env.VITE_APP_DELIVERY_CLASS);
      this.deliveryClassOne = deliveryClasses.deliveryClassOne;
      this.deliveryClassTwo = deliveryClasses.deliveryClassTwo;
      this.deliveryClassThree = deliveryClasses.deliveryClassThree;
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
    };
  },
}

</script>

<template>
  <div class="row">
    <div class="col-md-2">
      <!-- h3 -->
      <div class="form-group">
        <label>納入先コード</label>
        <input
            v-model="formDataSearch.delivery_cd"
            type="text"
            class="form-control">
      </div>
    </div>
    <!-- h4 -->
    <div class="col-md-2">
      <div class="form-group">
        <label>納入先名</label>
        <input v-model="formDataSearch.delivery_nm"
               type="text"
               class="form-control">
      </div>
    </div>

    <!-- h5 -->
    <div class="col-md-2">
      <div class="form-group">
        <label>フリガナ</label>
        <input v-model="formDataSearch.delivery_kn" type="text" class="form-control">
      </div>
    </div>
    <!-- h6 -->
    <div class="col-md-4">
      <div class="form-group">
        <label>住所</label>
        <input v-model="formDataSearch.address" type="text" class="form-control">
      </div>
    </div>
    <!-- h7 -->
    <div class="col-md-2">
      <div class="form-group">
        <label>電話番号</label>
        <input v-model="formDataSearch.tel" type="text" class="form-control">
      </div>
    </div>
  </div>

  <div class="row">
    <!-- h8 -->
    <div class="col-md-2">
      <div class="form-group">
        <label>納入先分類１</label>
        <select v-model="formDataSearch.delivery_class_1" class="form-select">
          <option value="0"></option>
          <option
              v-if="deliveryClassOne.length > 0"
              v-for="dc in deliveryClassOne"
              :value="dc.lib_val_cd">
            {{ dc.lib_val_nm }}
          </option>
        </select>
      </div>
    </div>
    <!-- h9 -->
    <div class="col-md-2">
      <div class="form-group">
        <label>納入先分類２</label>
        <select v-model="formDataSearch.delivery_class_2" class="form-select">
          <option value="0"></option>
          <option
              v-if="deliveryClassTwo.length > 0"
              v-for="dc in deliveryClassTwo"
              :value="dc.lib_val_cd">
            {{ dc.lib_val_nm }}
          </option>
        </select>
      </div>
    </div>
    <!-- h10 -->
    <div class="col-md-2">
      <div class="form-group">
        <label>納入先分類３</label>
        <select v-model="formDataSearch.delivery_class_3"  class="form-select">
          <option value="0"></option>
          <option
              v-if="deliveryClassThree.length > 0"
              v-for="dc in deliveryClassThree"
              :value="dc.lib_val_cd">
            {{ dc.lib_val_nm }}
          </option>
        </select>
      </div>
    </div>
  </div>

  <hr>

</template>

<style scoped>
@import 'css/css.css';
</style>
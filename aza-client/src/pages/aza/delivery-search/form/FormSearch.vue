<script>
import {getData} from "../service/HandleAPI.js";


export default {
  props: {
    formData: Object
  },
  methods: {
    async getDeliveryClasses() {
      let deliveryClasses = await getData(import.meta.env.VITE_APP_DELIVERY_CLASS);
      this.deliveryClassOne = deliveryClasses.deliveryClassOne;
      this.deliveryClassTwo = deliveryClasses.deliveryClassTwo;
      this.deliveryClassThree = deliveryClasses.deliveryClassThree;
    }
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
        <label class="form-label">納入先コード</label>
        <input
            v-model="formData.delivery_cd"
            type="text"
            maxlength="6"
            tabindex="11"
            data-maxlength="6"
            class="form-control">
      </div>
    </div>
    <!-- h4 -->
    <div class="col-md-2">
      <div class="form-group">
        <label class="form-label">納入先名</label>
        <input v-model="formData.delivery_nm"
               type="text"
               maxlength="90"
               tabindex="12"
               data-maxlength="90"
               class="form-control">
      </div>
    </div>

    <!-- h5 -->
    <div class="col-md-2">
      <div class="form-group">
        <label class="form-label">フリガナ</label>
        <input v-model="formData.delivery_kn"
               type="text"
               maxlength="140"
               tabindex="13"
               data-maxlength="140"
               class="form-control">
      </div>
    </div>
    <!-- h6 -->
    <div class="col-md-4">
      <div class="form-group">
        <label class="form-label">住所</label>
        <input v-model="formData.address"
               type="text"
               maxlength="400"
               tabindex="14"
               data-maxlength="400"
               class="form-control">
      </div>
    </div>
    <!-- h7 -->
    <div class="col-md-2">
      <div class="form-group">
        <label class="form-label">電話番号</label>
        <input v-model="formData.tel"
               type="text"
               maxlength="20"
               tabindex="15"
               data-maxlength="20"
               class="form-control">
      </div>
    </div>
  </div>

  <div class="row">
    <!-- h8 -->
    <div class="col-md-2">
      <div class="form-group">
        <label class="form-label">納入先分類１</label>
        <select
            v-model="formData.delivery_class_1"
            class="form-select form-control">
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
        <label class="form-label">納入先分類２</label>
        <select v-model="formData.delivery_class_2"
                class="form-select form-control">
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
        <label class="form-label">納入先分類３</label>
        <select
            v-model="formData.delivery_class_3"
            class="form-select form-control">
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
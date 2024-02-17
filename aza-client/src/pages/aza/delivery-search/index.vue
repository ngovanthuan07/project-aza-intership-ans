<template>
  <div class="content-container">
    <div class="content-header">
      <div class="content-header-left">
        <div class="content-header-item content-header-item-left">
          納入先一覧
        </div>
      </div>
    </div>
    <div class="condition-heading js-fix-before-header-panel">
      <div class="pull-left">
        <p class="search-title">検索条件</p>
      </div>
      <div class="pull-right">
        <font-awesome-icon :icon="['fas', !showFormLayout ? 'caret-down' : 'caret-up']" class="pull-icon"
                           @click="onChangeLayout"/>
      </div>
    </div>
    <div class="content">
      <div class="container-fluid">
        <div class="container-fluid">
          <FormSearch v-if="!showFormLayout"/>
          <DataTables />
        </div>

      </div>

    </div>
  </div>
</template>
<style scoped>
@import "./css/css.css";
</style>
<script>
import DataTables from './data-tables/DataTables.vue';
import FormSearch from "./form/FormSearch.vue";
import {ON_RESET_FORM_DATA} from "../../../store/modules/delivery-search/search-from/types.js";
import {AC_CHANGE_DATATABLES, RESET_STATE} from "../../../store/modules/data-table/types.js";

export default {
  components: {
    DataTables,
    FormSearch,
  },
  methods: {
    onChangeLayout() {
      this.showFormLayout = !this.showFormLayout;
    },
  },
  data() {
    return {
      showFormLayout: false
    }
  }
}

</script>
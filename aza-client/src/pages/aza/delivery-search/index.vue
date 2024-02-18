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
          <FormSearch
              :formData="formDataSearch"
              v-if="!showFormLayout"/>
          <SearchTable />
        </div>

      </div>

    </div>
  </div>
</template>
<style scoped>
@import "./css/css.css";
</style>
<script>
import FormSearch from "./form/FormSearch.vue";
import SearchTable from "./search-table/SearchTable.vue";
import {createNamespacedHelpers} from "vuex";
import {ON_RESET_FORM_DATA, UPDATE_FORM_DATA} from "../../../store/modules/delivery-search/search-from/types.js";
const {
  mapState: mapFormDataSearchState,
  mapActions: mapFormDataSearchActions
} = createNamespacedHelpers('formDataSearch');

export default {
  components: {
    SearchTable,
    FormSearch,
  },
  methods: {
   ...mapFormDataSearchActions([
      UPDATE_FORM_DATA, ON_RESET_FORM_DATA
   ]),
    onChangeLayout() {
      this.showFormLayout = !this.showFormLayout;
    },
  },
  computed: {
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
  },
  data() {
    return {
      showFormLayout: false
    }
  }
}

</script>
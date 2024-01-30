<script>
import {createNamespacedHelpers} from "vuex";
import axios from "axios";
import {URL_API_SEARCH} from "../../../../constants/api.js";

const { mapState: mapDatableState, mapActions: mapDatatableActions } = createNamespacedHelpers('dataTable');
const { mapState: mapFormDataSearchState, mapActions: mapFormDataSearchActions } = createNamespacedHelpers('formDataSearch');

  export default {
    components: {

    },
    methods: {
      async handleSearch() {

        let data = {
           ...this.formDataSearch,
          'sortType'    : this.sortOrder,
          'sortColumn'  : this.sortColumn,
          'currentPage' : this.currentPage,
          'limit'       : this.totalPages
        }

        console.log(data)

        let response = await axios.post(URL_API_SEARCH, data)
      },
    },
    computed: {
      ...mapFormDataSearchState({
        formDataSearch: state => state.formData
      }),
      ...mapDatableState({
          sortOrder:    state => state.sortOrder,
          sortColumn:   state => state.sortColumn,
          currentPage:  state => state.currentPage,
          totalPages:   state => state.totalPages,
          tables:       state => state.tables
      }),

    },
    data() {
      return {

      };
    }
  }

</script>

<template>
  <div class="toolbar-bottom">
      <div class="toolbar-bottom-left">
        <button type="button" class="btn">
          <font-awesome-icon :icon="['fas', 'caret-left']" />  戻る
        </button>
      </div>
      <div class="toolbar-bottom-right">
        <button class="btn">
          新規追加
        </button>
        <button class="btn">
          クリア
        </button>
        <button class="btn">
          EXCEL
        </button>
        <button class="btn btn-outline-primary" @click="handleSearch">
          <font-awesome-icon :icon="['fas', 'magnifying-glass']" />
        </button>
      </div>
  </div>
</template>

<style scoped>
@import './css/css.css';
</style>
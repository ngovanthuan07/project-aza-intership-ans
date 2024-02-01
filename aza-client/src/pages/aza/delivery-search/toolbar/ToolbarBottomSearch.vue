<script>
import { createNamespacedHelpers } from "vuex";
import axios from "axios";
import {
  AC_CHANGE_DATATABLES,
  CURRENT_PAGE, LIST_DATA, TOTAL_ITEMS, TOTAL_PAGES, UPDATE_STATE
} from "../../../../store/modules/data-table/types.js";
import { postData } from "../service/HandleAPI.js";


const { mapState: mapDatableState, mapActions: mapDatatableActions } = createNamespacedHelpers('dataTable');
const { mapState: mapFormDataSearchState, mapActions: mapFormDataSearchActions } = createNamespacedHelpers('formDataSearch');

export default {
  components: {

  },
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    async handleSearch() {
      let data = this.createDataObject('search');
      let result = await postData(import.meta.env.VITE_APP_API_SEARCH, data);
      this[AC_CHANGE_DATATABLES]({
          type: UPDATE_STATE,
          payload: {
            [CURRENT_PAGE]: 1,
            [TOTAL_ITEMS]: result.totalItems,
            [TOTAL_PAGES]: result.totalPages,
            [LIST_DATA]: result.resultSearch,
          }
      })
    },
    async handleExcel() {
      try {
        let data = this.createDataObject('excel');
        let filePath = (await postData(import.meta.env.VITE_APP_API_EXCEL, data))?.file_path;
        let fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
        const link = document.createElement('a');
        link.href = filePath;
        link.target = '_blank';
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      } catch (e) {
        console.log('Error download file:', e);
      }
    },
    createDataObject(type) {
      switch (type) {
        case 'search':
          return {
            ...this.formDataSearch,
            'sortType': this.sortOrder,
            'sortColumn': this.sortColumn,
            'currentPage': this.currentPage,
            'limit': this.pageSize
          };
        case 'excel':
          return this.formDataSearch;
      }
    }
  },
  computed: {
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    ...mapDatableState({
      sortOrder: state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      currentPage: state => state.currentPage,
      pageSize: state => state.pageSize,
      listData: state => state.listData
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
        <font-awesome-icon :icon="['fas', 'caret-left']" /> 戻る
      </button>
    </div>
    <div class="toolbar-bottom-right">
      <button class="btn">
        新規追加
      </button>
      <button class="btn">
        クリア
      </button>
      <button class="btn" @click="handleExcel">
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
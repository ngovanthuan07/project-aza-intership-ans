<script>
import { createNamespacedHelpers } from "vuex";
import axios from "axios";
import {
  AC_CHANGE_DATATABLES,
  CURRENT_PAGE, LIST_DATA, RESET_STATE, TOTAL_ITEMS, TOTAL_PAGES, UPDATE_STATE
} from "../../../../store/modules/data-table/types.js";
import { postData } from "../service/HandleAPI.js";
import {SHOW_LOADING_A} from "../../../../store/modules/loading-spinner/types.js";
import {ON_RESET_FORM_DATA} from "../../../../store/modules/delivery-search/search-from/types.js";
import formSearch from "../form/FormSearch.vue";
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

import {
  notificationSuccess,
  notificationError
} from '../../../../helpers/notification.js'
import {NOTIFICATION_ERROR, NOTIFICATION_SUCCESS} from "../../../../constants/notification.js";



export default {
  components: {

  },
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    ...mapFormDataSearchActions([
      ON_RESET_FORM_DATA
    ]),
    ...mapLoadingActions([
      SHOW_LOADING_A
    ]),
    async handleSearch() {
      try {
        this[SHOW_LOADING_A](true)
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
      } catch (e) {
        notificationError(NOTIFICATION_ERROR)
        console.error(e)
      } finally {
        this[SHOW_LOADING_A](false)
      }

    },
    async handleExcel() {
      try {
        this[SHOW_LOADING_A](true)
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
        // notificationSuccess(NOTIFICATION_SUCCESS)
      } catch (e) {
        notificationError(NOTIFICATION_ERROR)
        console.log('Error download file:', e);
      } finally {
        this[SHOW_LOADING_A](false)
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
    },
    handleRedirectDeliveryDetail() {
      this.$router.push({ name: 'delivery-detail' });
    },
    handleResetSearch() {
      this[SHOW_LOADING_A](true)
      this[ON_RESET_FORM_DATA]()
      this[AC_CHANGE_DATATABLES]({type: RESET_STATE, payload: null})
      this[SHOW_LOADING_A](false)
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
    ...mapLoadingState({
      showLoading: state => state.showLoading
    })
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
      <button class="btn" @click="handleRedirectDeliveryDetail">
        新規追加
      </button>
      <button class="btn" @click="handleResetSearch">
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
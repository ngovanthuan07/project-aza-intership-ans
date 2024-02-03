<template>
  <div class="box-top">
    <div class="box-select-page">
      <div v-if="totalPages > 0" >
        <select v-model="pageS"  @change="handlePageSize" class="form-select">
          <option v-for="option in selectOptions"
                  :value="option.value">
            {{ option.text }}
          </option>
        </select>
      </div>
      <div v-if="this.totalItems" class="text-page">
        <span> {{ this.totalItems }} 件中 {{ this.onStart() }} - {{ this.onLast() }} 件</span>
      </div>
    </div>
    <div>
   <Pagination/>
    </div>
  </div>

  <Table :columns="columns"/>

  <div class="box-bottom">
    <Pagination/>
  </div>
</template>
<script>
import Pagination from './pagination/Pagination.vue';
import Table from "./table/Table.vue";
import {createNamespacedHelpers} from "vuex";
import {
  AC_CHANGE_DATATABLES, CURRENT_PAGE, LIST_DATA, PAGE_SIZE,
  TOTAL_PAGES, UPDATE_STATE
} from "../../../../store/modules/data-table/types.js";

import searchColumns from "./constants/search-columns.js";
import selectOptionPageSize from "./constants/select-option-page-size.js";
import {getData, postData} from "../service/HandleAPI.js";
import {SHOW_LOADING_A} from "../../../../store/modules/loading-spinner/types.js";
import {notificationError} from "../../../../helpers/notification.js";
import {NOTIFICATION_ERROR} from "../../../../constants/notification.js";
const {
  mapState: mapLoadingState,
  mapActions: mapLoadingActions
} = createNamespacedHelpers('loadingSpinner');
const {
  mapState: mapDatableState,
  mapActions: mapDatatableActions
} = createNamespacedHelpers('dataTable');
const {
  mapState: mapFormDataSearchState,
  mapActions: mapFormDataSearchActions
} = createNamespacedHelpers('formDataSearch');

export default {
  components: {
    Pagination,
    Table
  },
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    ...mapLoadingActions([
      SHOW_LOADING_A
    ]),
    async handlePageSize() {
      {
        try {
          this[SHOW_LOADING_A](true)
          let dataSelect = {
            ...this.formDataSearch,
            'sortType': this.sortOrder,
            'sortColumn': this.sortColumn,
            'currentPage': 1,
            'limit': this.pageS
          }
          let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);

          this[AC_CHANGE_DATATABLES]({
            type: UPDATE_STATE,
            payload: {
              [PAGE_SIZE]    : this.pageS,
              [CURRENT_PAGE] : 1,
              [TOTAL_PAGES]  : result.totalPages,
              [LIST_DATA]    : result.resultSearch,
            }
          })
        } catch (e) {
          notificationError(NOTIFICATION_ERROR)
          console.error(e)
        } finally {
          this[SHOW_LOADING_A](false)
        }
      }
    },
    onStart() {
      return this.pageSize * (this.currentPage - 1) + 1;
    },
    onLast() {
      return this.onStart() + this.listData.length - 1
    }
  },
  computed: {
    ...mapDatableState({
      sortOrder: state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      currentPage: state => state.currentPage,
      pageSize: state => state.pageSize,
      totalPages: state => state.totalPages,
      listData: state => state.listData,
      totalItems: state => state.totalItems
    }),
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    ...mapLoadingState({
      showLoading: state => state.showLoading
    })
  },
  setup() {
    let columns = searchColumns;
    return {
      columns
    }
  },
  data() {
    let selectOptions = selectOptionPageSize
    let pageS = 0

    return {
      pageS,
      selectOptions
    };
  },
  created() {
    this.pageS = this.pageS ? this.pageS : this.pageSize;
  }
}

</script>

<style scoped>
@import 'css/css.css';
</style>
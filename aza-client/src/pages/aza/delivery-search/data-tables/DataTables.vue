<template>
  <div class="box-top">
    <div class="box-select-page">
      <div>
        <select v-if="totalPages > 0" v-model="pageS" @change="handlePageSize" class="form-select">
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
import {ref} from 'vue'

import Pagination from './pagination/Pagination.vue';
import Table from "./table/Table.vue";
import {createNamespacedHelpers} from "vuex";
import {
  AC_CHANGE_DATATABLES, CURRENT_PAGE, LIST_DATA, PAGE_SIZE, TOTAL_ITEMS, TOTAL_PAGES, UPDATE_STATE

} from "../../../../store/modules/data-table/types.js";

import {UPDATE_DATA} from "../../../../store/modules/delivery-search/data-search/types.js";
import searchColumns from "./constants/search-columns.js";
import selectOptionPageSize from "./constants/select-option-page-size.js";
import {postData} from "../service/HandleAPI.js";

const {mapState: mapDatableState, mapActions: mapDatatableActions} = createNamespacedHelpers('dataTable');
const {
  mapState: mapFormDataSearchState,
  mapActions: mapFormDataSearchActions
} = createNamespacedHelpers('formDataSearch');
const {mapState: mapSearchDataState, mapActions: mapSearchDataActions} = createNamespacedHelpers('dataSearch');

export default {
  components: {
    Pagination,
    Table
  },
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    ...mapSearchDataActions([
      UPDATE_DATA
    ]),
    async handlePageSize() {
      {
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

    return {
      pageS: '',
      selectOptions
    };
  }
}

</script>

<style scoped>
@import 'css/css.css';
</style>
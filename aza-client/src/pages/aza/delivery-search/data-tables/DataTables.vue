<template>
    <div class="box-top">
      <div class="box-select-page">
        <div>
          <select v-if="totalPages > 0"  v-model="pageS" @change="handlePageSize" class="form-select">
            <option v-for="option in selectOptions"
                    :value="option.value">
                    {{option.text}}
            </option>
          </select>
        </div>
        <div v-if="this.totalItems" class="text-page">
          <span> {{this.totalItems}} 件中 {{this.onStart()}} - {{this.onLast()}} 件</span>
        </div>
      </div>
      <div>
        <Pagination />
      </div>
    </div>

    <Table :columns="columns"/>

   <div class="box-bottom">
     <Pagination />
   </div>
</template>
<script>
import { ref } from 'vue'

import Pagination from './pagination/Pagination.vue';
import Table from "./table/Table.vue";
import {createNamespacedHelpers} from "vuex";
import {
  AC_CHANGE_DATATABLES, CURRENT_PAGE, LIST_DATA, PAGE_SIZE, TOTAL_ITEMS, TOTAL_PAGES

} from "../../../../store/modules/data-table/types.js";

import {UPDATE_DATA} from "../../../../store/modules/delivery-search/data-search/types.js";
import searchColumns from "./constants/search-columns.js";
import selectOptionPageSize from "./constants/select-option-page-size.js";
import {postData} from "../service/HandleAPI.js";
const { mapState: mapDatableState, mapActions: mapDatatableActions } = createNamespacedHelpers('dataTable');
const { mapState: mapFormDataSearchState, mapActions: mapFormDataSearchActions } = createNamespacedHelpers('formDataSearch');
const { mapState: mapSearchDataState, mapActions: mapSearchDataActions } = createNamespacedHelpers('dataSearch');

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
      this[AC_CHANGE_DATATABLES]({
        type: PAGE_SIZE,
        payload: this.pageS
      })
      this[AC_CHANGE_DATATABLES]({
        type: CURRENT_PAGE,
        payload: 1,
      })
      {
      let dataSelect = {
          ...this.formDataSearch,
          'sortType'    : this.sortOrder,
          'sortColumn'  : this.sortColumn,
          'currentPage' : this.currentPage,
          'limit'       : this.pageSize
      }
      let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);
        this[AC_CHANGE_DATATABLES]({
          type: TOTAL_PAGES,
          payload: result.totalPages,
        })
        this[AC_CHANGE_DATATABLES]({
          type: LIST_DATA,
          payload: result.resultSearch,
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
      sortOrder:    state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      currentPage:  state => state.currentPage,
      pageSize:   state => state.pageSize,
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
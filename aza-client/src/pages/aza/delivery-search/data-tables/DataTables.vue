<template>
    <div class="box-top">
      <div class="box-select-page">
        <div>
          <select   v-model="pageS" @blur="handlePageSize" class="form-select">
            <option v-for="option in selectOptions"
                    :value="option.value">
                    {{option.text}}
            </option>
          </select>
        </div>
<!--        <div class="text-page">-->
<!--          <span> 件中 {{this.currentPage}} - {{this.currentPage*this.page}} 件</span>-->
<!--        </div>-->
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
  AC_CHANGE_DATATABLES, PAGE_SIZE

} from "../../../../store/modules/data-table/types.js";

import {UPDATE_DATA} from "../../../../store/modules/delivery-search/data-search/types.js";
import searchColumns from "./constants/search-columns.js";
import selectOptionPageSize from "./constants/select-option-page-size.js";
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
      console.log(this.pageSize)
    },
  },
  computed: {
    ...mapDatableState({
      pageSize: state => state.pageSize,
      currentPage: state => state.currentPage,
      totalPages: state => state.totalPages,
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
  },
}

</script>

<style scoped>
@import 'css/css.css';
</style>
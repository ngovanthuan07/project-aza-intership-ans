<template>
    <div class="box-top">
      <div class="box-select-page">
        <div>
          <select v-model="pageSize" @blur="handlePageSize" class="form-select">
            <option value="1">10件</option>
            <option value="2">50件</option>
            <option value="3">100件</option>
          </select>
        </div>
        <div class="text-page">
          <span> 件中 {{this.currentPage}} - {{this.currentPage*this.page}} 件</span>
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
  CHANGE_CURRENT_PAGE,
  CHANGE_PAGE_SIZE,
  CHANGE_TOTAL_PAGES,
  SET_TOTAL_PAGES
} from "../../store/modules/data-table/types.js";
import {URL_API_SEARCH} from "../../constants/api.js";
import {UPDATE_DATA} from "../../store/modules/delivery-search/data-search/types.js";
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
      CHANGE_PAGE_SIZE
    ]),
    ...mapSearchDataActions([
      UPDATE_DATA
    ]),
    ...mapDatatableActions([
      CHANGE_CURRENT_PAGE,
      CHANGE_TOTAL_PAGES
    ]),
    async handlePageSize() {
      this[CHANGE_PAGE_SIZE](this.pageSize)
      this[CHANGE_CURRENT_PAGE](1)
      this[CHANGE_TOTAL_PAGES](Math.floor(this.datas.length / this.page) + 1)
    },
  },
  computed: {
    ...mapDatableState({
      page: state => state.pageSize,
      currentPage: state => state.currentPage,
      totalPages: state => state.totalPages,
    }),
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    ...mapSearchDataState({
      datas: state => state.datas,
    })
  },
  setup() {
    let columns = [
      {
        title: '納入先コード',
        column: 'd4',
      },
      {
        title: '納入先名',
        column: 'd5'
      },
      {
        title: 'フリガナ',
        column: 'd6'
      },
      {
        title: '住所',
        column: 'd7'
      },
      {
        title: '電話番号',
        column: 'd8'
      },
      {
        title: '納入先分類１',
        column: 'd9'
      },
      {
        title: '納入先分類２',
        column: 'd10'
      },
      {
        title: '納入先分類３',
        column: 'd11'
      }
    ]

    return {
      columns
    }
  },
  data() {
    return {
      pageSize: '',
    };
  },
}

</script>

<style scoped>
.box-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}
.box-top .box-select-page {
  display: flex;
  justify-content: center;
  align-items: center;

}
.box-top .box-select-page .text-page {
  font-size: 15px;
  padding-left: 10px;
}
.box-bottom {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}
</style>
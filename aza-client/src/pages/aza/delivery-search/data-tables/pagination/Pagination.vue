<template>
  <nav v-if="totalPages > 0" aria-label="Page navigation pagination-nav">
    <ul class="pagination">
      <li class="page-item">
        <button @click="onStartPage()" class="page-link" href="#" aria-label="Previous">
          <span aria-hidden="true">&lt;&lt;</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onPrevPage()" class="page-link" href="#" aria-label="Previous">
          <span aria-hidden="true">&lt;</span>
        </button>
      </li>
      <li class="page-item" v-for="(page) in filteredPagination">
        <button @click="onChangePage(page)" class="page-link" :class="{ 'active': isActive(page) }" href="#">
          <span> {{ page > 0 ? page : '...' }}</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onNextPage()" class="page-link" href="#" aria-label="Next">
          <span aria-hidden="true">&gt;</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onEndPage()" class="page-link" href="#" aria-label="Next">
          <span aria-hidden="true">&gt;&gt;</span>
        </button>
      </li>
    </ul>
  </nav>
</template>

<script>
import {handListPage} from '../../../../../helpers/pagination.js';
import {AC_CHANGE_DATATABLES, CURRENT_PAGE, LIST_DATA} from "../../../../../store/modules/data-table/types.js";
import {createNamespacedHelpers} from 'vuex';
import {postData} from "../../service/HandleAPI.js";

const {mapState: mapDatableState, mapActions: mapDatatableActions} = createNamespacedHelpers('dataTable');
const { mapState: mapFormDataSearchState, mapActions: mapFormDataSearchActions } = createNamespacedHelpers('formDataSearch');
const { mapState: mapSearchDataState, mapActions: mapSearchDataActions } = createNamespacedHelpers('dataSearch');


export default {
  props: {},
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    onChangePage(page) {
      if (page === -1 || page === this.currentPage) return;
      this.changePage(page);
    },
    onStartPage() {
      this.changePage(this.startPage);
    },
    onPrevPage() {
      if (this.currentPage > this.startPage) {
        this.changePage(this.currentPage - 1);
      }
    },
    onNextPage() {
      if (this.currentPage < this.totalPages) {
        this.changePage(this.currentPage + 1);
      }
    },
    onEndPage() {
      this.changePage(this.totalPages);
    },
    async changePage(page) {
      try {
        this[AC_CHANGE_DATATABLES]({
          type: CURRENT_PAGE,
          payload: page
        });
        let dataSelect = {
          ...this.formDataSearch,
          'sortType'    : this.sortOrder,
          'sortColumn'  : this.sortColumn,
          'currentPage' : this.currentPage,
          'limit'       : this.pageSize
        }
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);
        this[AC_CHANGE_DATATABLES]({
          type: LIST_DATA,
          payload: result.resultSearch,
        })
        console.log('Change current page successful');
      } catch (error) {
        console.error('Error changing current page:', error);
      }
    },
    isActive(page) {
      let curP = this.currentPage * 1;
      return curP === page ? true : false;
    }
  },
  computed: {
    ...mapDatableState({
      sortOrder:    state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      currentPage:  state => state.currentPage,
      pageSize:   state => state.pageSize,
      totalPages: state => state.totalPages,
      startPage: state => state.startPage
    }),
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    filteredPagination() {
      return handListPage(this.startPage, this.totalPages, this.currentPage);
    }
  },
  setup(props) {

    return {};
  },
  data() {
    return {}
  }
};
</script>

<style scoped>
@import 'css/css.css';
</style>
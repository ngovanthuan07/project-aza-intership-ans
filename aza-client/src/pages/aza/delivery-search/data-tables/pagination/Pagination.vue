<template>
  <nav v-if="totalPages > 0" aria-label="Page navigation pagination-nav">
    <ul class="pagination">
      <li class="page-item">
        <button @click="onStartPage()" :disabled="isUnFirstActive(this.currentPage)" :class="{ 'un-active': isUnFirstActive(this.currentPage) }" class="page-link" href="#" aria-label="Previous">
          <span aria-hidden="true">&lt;&lt;</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onPrevPage()" :disabled="isUnFirstActive(this.currentPage)"  :class="{ 'un-active': isUnFirstActive(this.currentPage) }"  class="page-link" href="#" aria-label="Previous">
          <span aria-hidden="true">&lt;</span>
        </button>
      </li>
      <li class="page-item" v-for="(page) in filteredPagination">
        <button v-if="page > 0" @click="onChangePage(page)" class="page-link" :class="{ 'active': isActive(page) }" href="#">
          <span v-if="page > 0"> {{page}} </span>
        </button>
        <div class="page-hidden" v-if="page < 0" @click="onShowFirstPage(true)">
          <span> ... </span>
        </div>
      </li>
      <li class="page-item">
        <button @click="onNextPage()" :disabled="isUnEndActive(this.currentPage)" :class="{ 'un-active': isUnEndActive(this.currentPage) }"  class="page-link" href="#" aria-label="Next">
          <span aria-hidden="true">&gt;</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onEndPage()" :disabled="isUnEndActive(this.currentPage)" :class="{ 'un-active': isUnEndActive(this.currentPage) }"  class="page-link" href="#" aria-label="Next">
          <span aria-hidden="true">&gt;&gt;</span>
        </button>
      </li>
    </ul>
  </nav>
</template>

<script>
import {handListPage} from '../../../../../helpers/pagination.js';
import {
  AC_CHANGE_DATATABLES,
  CURRENT_PAGE,
  LIST_DATA, SHOW_PAGE_HIDDEN,
  UPDATE_STATE
} from "../../../../../store/modules/data-table/types.js";
import {createNamespacedHelpers} from 'vuex';
import {postData} from "../../service/HandleAPI.js";

const {mapState: mapDatableState, mapActions: mapDatatableActions} = createNamespacedHelpers('dataTable');
const { mapState: mapFormDataSearchState, mapActions: mapFormDataSearchActions } = createNamespacedHelpers('formDataSearch');


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
      console.log(this.totalPages)
      this.changePage(this.totalPages);
    },
     onShowFirstPage(value) {
      console.log(value)
       this[AC_CHANGE_DATATABLES]({
        type: UPDATE_STATE,
        payload: {
          [SHOW_PAGE_HIDDEN]: value
        }
      })
    },
    async changePage(page) {
      try {
        let dataSelect = {
          ...this.formDataSearch,
          'sortType'    : this.sortOrder,
          'sortColumn'  : this.sortColumn,
          'currentPage' : page,
          'limit'       : this.pageSize
        }
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);
        this[AC_CHANGE_DATATABLES]({
          type: UPDATE_STATE,
          payload: {
            [CURRENT_PAGE]  : page,
            [LIST_DATA]     : result.resultSearch,
            [SHOW_PAGE_HIDDEN]: false
          }
        });
        console.log('Change current page successful');
      } catch (error) {
        console.error('Error changing current page:', error);
      }
    },
    isActive(page) {
      return this.currentPage === page ? true : false;
    },
    isUnFirstActive() {
      return this.currentPage === this.startPage ? true : false;
    },
    isUnEndActive() {
      return this.currentPage === this.totalPages ? true : false;
    }
  },
  computed: {
    ...mapDatableState({
      sortOrder:    state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      currentPage:  state => state.currentPage,
      pageSize:   state => state.pageSize,
      totalPages: state => state.totalPages,
      startPage: state => state.startPage,
      showPageHidden: state => state.showPageHidden
    }),
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    filteredPagination() {
      return handListPage(this.startPage, this.totalPages, this.currentPage, this.showPageHidden);
    }
  },
  setup(props) {

    return {};
  },
  data() {
    return {

    }
  }
};
</script>

<style scoped>
@import 'css/css.css';
</style>
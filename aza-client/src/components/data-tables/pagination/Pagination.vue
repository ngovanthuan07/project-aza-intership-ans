<template>
  <nav v-if="totalPages > 0" aria-label="Page navigation pagination-nav">
    <ul class="pagination">
      <li class="page-item">
        <button @click="onStartPage()" :disabled="isUnFirstActive(currentPage)" :class="{ 'un-active': isUnFirstActive(this.currentPage) }" class="page-link" href="#" aria-label="Previous">
          <span aria-hidden="true">&lt;&lt;</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onPrevPage()" :disabled="isUnFirstActive(currentPage)"  :class="{ 'un-active': isUnFirstActive(this.currentPage) }"  class="page-link" href="#" aria-label="Previous">
          <span aria-hidden="true">&lt;</span>
        </button>
      </li>
      <li class="page-item" v-for="(page) in filteredPagination">
        <button v-if="page > 0" @click="onChangePage(page)" class="page-link" :class="{ 'active': isActive(page) }" href="#">
          <span v-if="page > 0"> {{page}} </span>
        </button>
        <div class="page-hidden" v-if="page < 0">
          <span> ... </span>
        </div>
      </li>
      <li class="page-item">
        <button @click="onNextPage()" :disabled="isUnEndActive(currentPage)" :class="{ 'un-active': isUnEndActive(currentPage) }"  class="page-link" href="#" aria-label="Next">
          <span aria-hidden="true">&gt;</span>
        </button>
      </li>
      <li class="page-item">
        <button @click="onEndPage()" :disabled="isUnEndActive(currentPage)" :class="{ 'un-active': isUnEndActive(currentPage) }"  class="page-link" href="#" aria-label="Next">
          <span aria-hidden="true">&gt;&gt;</span>
        </button>
      </li>
    </ul>
  </nav>
</template>

<script>
import {handListPage} from '../../../helpers/pagination.js';

export default {
  props: {
    currentPage:    Number,
    pageSize   :    Number,
    totalPages :    Number,
    startPage  :    Number,
    handleChangePage :    Function
  },
  methods: {
    onChangePage(page) {
      if (page === -1 || page === this.currentPage) return;
      this.handleChangePage(page);
    },
    onStartPage() {
      this.handleChangePage(this.startPage);
    },
    onPrevPage() {
      if (this.currentPage > this.startPage) {
        this.handleChangePage(this.currentPage - 1);
      }
    },
    onNextPage() {
      if (this.currentPage < this.totalPages) {
        this.handleChangePage(this.currentPage + 1);
      }
    },
    onEndPage() {
      console.log(this.totalPages)
      this.handleChangePage(this.totalPages);
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
    filteredPagination() {
      return handListPage(this.startPage, this.totalPages, this.currentPage);
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
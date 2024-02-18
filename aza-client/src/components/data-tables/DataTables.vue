<template>
  <div class="box-top">
    <div class="box-select-page">
      <select v-model="pageS"
              @change="handlePageSelectSize(pageS)"
              class="form-select form-control"
              tabindex="16">
        <option v-for="option in selectOptions"
                :value="option.value">
          {{ option.text }}
        </option>
      </select>
      <div v-if="totalItems" class="text-page total-record">
        <span> {{ totalItems }} 件中 {{ this.onStart() }} - {{ this.onLast() }} 件</span>
      </div>
      <div v-if="totalItems === 0" class="text-page total-record">
        <span> 検索結果 </span>
      </div>
    </div>
    <div>
      <Pagination
          :currentPage = "currentPage"
          :pageSize   = "pageSize"
          :totalPages = "totalPages"
          :startPage  = "startPage"
          :handleChangePage = "handleChangePage"
      />
    </div>
  </div>

  <Table
      :headers="headers"
      :fields="fields"
      :items="items"
      :handleOnClickItem = "handleRelativePage"
      :keyItem="keyItem"
      :sortColumn="sortColumn"
      :sortOrder="sortOrder"
      :totalPages = "totalPages"
      :onSortable = "handleSortable"
  />

  <div class="box-bottom">
    <Pagination
        :currentPage = "currentPage"
        :pageSize   = "pageSize"
        :totalPages = "totalPages"
        :startPage  = "startPage"
        :handleChangePage = "handleChangePage"
    />
  </div>
</template>
<script>
import Pagination from './pagination/Pagination.vue';
import Table from "./table/Table.vue";
import selectOptionPageSize from "../../pages/aza/delivery-search/search-table/js/selectOptionPageSizeO.js";

export default {
  components: {
    Pagination,
    Table
  },
  props: {
    keyItem                   :undefined,
    headers                   :Array,
    fields                    :Array,
    items                     :Array,
    sortColumn                :String,
    sortOrder                 :String,
    currentPage               :Number,
    totalItems                :Number,
    pageSize                  :Number,
    totalPages                :Number,
    startPage                 :Number,
    selectOptions             :Array,
    onChangePage              :Function,
    onSortable                :Function,
    onChangeSelectorPageSize  :Function,
    onRelativePage            :Function
  },
  methods: {
    async handlePageSelectSize(ps) {
      await this.onChangeSelectorPageSize(ps)
    },
    async handleChangePage(page) {
      await this.onChangePage(page)
    },
    async handleRelativePage(value) {
      await this.onRelativePage(value)
    },
    async handleSortable(column) {
      await this.onSortable(column)
    },
    onStart() {
      return this.pageSize * (this.currentPage - 1) + 1;
    },
    onLast() {
      return this.onStart() + this.items.length - 1
    },
  },
  data() {
    let pageS = 0

    return {
      pageS
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
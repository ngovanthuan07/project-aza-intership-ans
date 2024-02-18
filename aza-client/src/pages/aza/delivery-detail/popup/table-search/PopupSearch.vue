<script>
import FormSearch from "../../../delivery-search/form/FormSearch.vue";
import DataTables from "../../../../../components/data-tables/DataTables.vue";
import {SHOW_LOADING_A} from "../../../../../store/modules/loading-spinner/types.js";
import {postData} from "../../../delivery-search/service/HandleAPI.js";
import {createNamespacedHelpers} from "vuex";
import formSearchO from "./js/formSearchO.js";
import dataTableSearchO from "./js/dataTableSearchO.js";
import * as tableSearchCustomO from './js/tableSearchCustomO.js'
import {ASC, DESC} from "../../../../../constants/sortConstant.js";
import selectOptionPageSize from "../../../delivery-search/search-table/js/selectOptionPageSizeO.js";
import {errorAlert} from "../../../../../common/modal/popupSwal.js";
import {NOTIFICATION_ERROR} from "../../../../../constants/notification.js";
const {
  mapState: mapLoadingState,
  mapActions: mapLoadingActions
} = createNamespacedHelpers('loadingSpinner');
export default {
  components: {
    FormSearch,
    DataTables
  },
  props: {
    handlePopUp       : Function,
    togglePopup       : Boolean,
    handleClosePopUp  : Function
  },
  methods: {
    ...mapLoadingActions([
      SHOW_LOADING_A
    ]),
    async onChangeSelectorPageSize(pPageSize) {
      {
        try {
          this[SHOW_LOADING_A](true)
          let dataSelect = {
            ...this.formData,
            'sortType'    : this.searchable.sortOrder,
            'sortColumn'  :  this.searchable.sortColumn,
            'currentPage' : 1,
            'limit'       : pPageSize
          }
          let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);

          this.searchable.pageSize     = pPageSize
          this.searchable.currentPage  = 1
          this.searchable.totalPages   = result.totalItems
          this.searchable.totalPages   = result.totalPages
          this.searchable.listData     = result.resultSearch
        } catch (e) {
          console.error(e)
          errorAlert('', NOTIFICATION_ERROR)
        } finally {
          this[SHOW_LOADING_A](false)
        }
      }
    },

    async onChangePage(page) {
      try {
        this[SHOW_LOADING_A](true)
        let dataSelect = {
          ...this.formData,
          'sortType': this.searchable.sortOrder,
          'sortColumn': this.searchable.sortColumn,
          'currentPage': page,
          'limit': this.searchable.pageSize
        }
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);

        this.searchable.currentPage  = page
        this.searchable.listData     = result.resultSearch
        console.log('Change current page successful');
      } catch (error) {
        console.error('Error changing current page:', error);
        errorAlert('', NOTIFICATION_ERROR)
      } finally {
        this[SHOW_LOADING_A](false)
      }
    },

    async onRelativePage(value) {
      await this.handlePopUp(value)
      await this.onClosePopup()
    },
    // handle search
    async handleSearch() {
      try {
        this[SHOW_LOADING_A](true)
        let data = this.createDataObject('search');
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, data);

        this.searchable.currentPage = 1;
        this.searchable.totalItems  = result.totalItems;
        this.searchable.totalPages  = result.totalPages;
        this.searchable.listData    = result.resultSearch
      } catch (e) {
        console.error(e)
        errorAlert('', NOTIFICATION_ERROR)
      } finally {
        this[SHOW_LOADING_A](false)
      }
    },
    async onSortable(column) {
      try {
        if (column === this.searchable.sortColumn) {
          let tSort = this.searchable.sortOrder === ASC ? DESC : ASC;
          this.searchable.sortOrder = tSort
        } else {
          this.searchable.sortColumn = column
          this.searchable.sortOrder = ASC
        }
        let dataSort = {
          ...this.formData,
          'sortType': this.searchable.sortOrder,
          'sortColumn': this.searchable.sortColumn,
          'currentPage': this.searchable.currentPage,
          'limit': this.searchable.pageSize
        }
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSort);
        this.searchable.listData = result.resultSearch
      } catch (e) {
        console.error(e)
        errorAlert('', NOTIFICATION_ERROR)
      }
    },
    createDataObject(type) {
      switch (type) {
        case 'search':
          return {
            ...this.formData,
            'sortType': this.searchable.sortOrder,
            'sortColumn': this.searchable.sortColumn,
            'currentPage': this.searchable.currentPage,
            'limit': this.searchable.pageSize
          };
      }
    },
    onChangeLayout() {
      this.showFormLayout = !this.showFormLayout;
    },
    onResetSearch() {
      this.searchable = {
        sortOrder: 'ASC',
        sortOrders: [],
        sortColumn: null,
        pageSize: 10,
        currentPage: 1,
        totalItems: 0,
        totalPages: 0,
        startPage: 1,
        listData: []
      };
      this.formData = {
        delivery_cd: '',
        delivery_nm: '',
        delivery_kn: '',
        address: '',
        tel: '',
        delivery_class_1: 0,
        delivery_class_2: 0,
        delivery_class_3: 0,
      }
    },
    async onClosePopup() {
       await this.handleClosePopUp()
       this.onResetSearch()
    }
  },
  computed: {
    ...mapLoadingState({
      showLoading: state => state.showLoading
    }),
  },
  setup() {
    return {
      keyItem: 'delivery_cd'
    }
  },
  data() {
    let headers        = tableSearchCustomO.headers;
    let fields         = tableSearchCustomO.fields;
    let formData       = formSearchO;
    let searchable     = dataTableSearchO;
    let selectOptions  = selectOptionPageSize;
    return {
      formData,
      searchable,
      selectOptions,
      headers,
      fields,
      showFormLayout: false
    }
  }
}
</script>

<template>
  <div
      v-if="togglePopup"
      class="modal fade show"
      id="searchModal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
      tabindex="-1"
      style="display: block"
      aria-labelledby="searchLabel"
      aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered d-flex align-items-center justify-content-center">
      <div class="modal-content ">
        <div class="modal-header">
          <button type="button"
                  class="btn-close"
                  @click="onClosePopup">
          </button>
        </div>
        <div class="modal-body">
          <div class="condition-heading js-fix-before-header-panel">
            <div class="pull-left">
              <p class="search-title">検索条件</p>
            </div>
            <div class="pull-right">
              <font-awesome-icon :icon="['fas', !showFormLayout ? 'caret-down' : 'caret-up']" class="pull-icon"
                                 @click="onChangeLayout"/>
            </div>
          </div>
          <FormSearch
              :formData="formData"
              v-if="!showFormLayout"/>
            <div class="toolbar-bottom">
              <div class="toolbar-bottom-left">
              </div>
              <div class="toolbar-bottom-right">
                <button class="btn" @click="handleSearch" tabindex="104">
                  <font-awesome-icon :icon="['fas', 'magnifying-glass']" />
                </button>
              </div>
            </div>
          <DataTables
              :keyItem                       = "keyItem"
              :headers                       = "headers"
              :fields                        = "fields"
              :items                         = "searchable.listData"
              :sortColumn                    = "searchable.sortColumn"
              :sortOrder                     = "searchable.sortOrder"
              :currentPage                   = "searchable.currentPage"
              :totalItems                    = "searchable.totalItems"
              :pageSize                      = "searchable.pageSize"
              :totalPages                    = "searchable.totalPages"
              :startPage                     = "searchable.startPage"
              :selectOptions                 = "selectOptions"
              :onChangePage                  = "onChangePage"
              :onSortable                    = "onSortable"
              :onChangeSelectorPageSize      = "onChangeSelectorPageSize"
              :onRelativePage                = "onRelativePage"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import "css/css.css";
</style>
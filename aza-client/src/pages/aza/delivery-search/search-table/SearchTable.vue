<template>
  <DataTables
      :keyItem                       = "keyItem"
      :headers                       = "headers"
      :fields                        = "fields"
      :items                         = "listData"
      :sortColumn                    = "sortColumn"
      :sortOrder                     = "sortOrder"
      :currentPage                   = "currentPage"
      :totalItems                    = "totalItems"
      :pageSize                      = "pageSize"
      :totalPages                    = "totalPages"
      :startPage                     = "startPage"
      :selectOptions                 = "selectOptions"
      :onChangePage                  = "onChangePage"
      :onSortable                    = "onSortable"
      :onChangeSelectorPageSize      = "onChangeSelectorPageSize"
      :onRelativePage                = "onRelativePage"
  />
</template>
<script>
import {createNamespacedHelpers} from "vuex";
import {
  AC_CHANGE_DATATABLES, CURRENT_PAGE, LIST_DATA, PAGE_SIZE, SORT_COLUMN, SORT_ORDER, TOTAL_ITEMS, TOTAL_PAGES, UPDATE_STATE
} from "../../../../store/modules/data-table/types.js";
import * as searchTable from "./js/tableSearchCustomO.js";
import selectOptionPageSize from "./js/selectOptionPageSizeO.js";
import {getData, postData} from "../service/HandleAPI.js";
import {SHOW_LOADING_A} from "../../../../store/modules/loading-spinner/types.js";
import {notificationError} from "../../../../helpers/notification.js";
import {NOTIFICATION_ERROR} from "../../../../constants/notification.js";
import DataTables from "../../../../components/data-tables/DataTables.vue";
import {errorAlert} from "../../../../common/modal/popupSwal.js";
import {ASC, DESC} from "../../../../constants/sortConstant.js";
import {setLocalStorage} from "../../../../common/client-side-storage/clientStorage.js";
import {DELIVERY_DETAIL} from "../../../../constants/clientConstant.js";
import loadDelivery from "../service/deliveryLoadData.js";
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
  components:{
    DataTables
  },
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    ...mapLoadingActions([
      SHOW_LOADING_A
    ]),
    uploadDatable(payload) {
      this[AC_CHANGE_DATATABLES]({
        type: UPDATE_STATE,
        payload
      })
    },
    async onChangeSelectorPageSize(pPageSize) {
    {
        try {
          this[SHOW_LOADING_A](true)
          let dataSelect = {
            ...this.formDataSearch,
            'sortType': this.sortOrder,
            'sortColumn': this.sortColumn,
            'currentPage': 1,
            'limit': pPageSize
          }
          let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);

          this[AC_CHANGE_DATATABLES]({
            type: UPDATE_STATE,
            payload: {
              [PAGE_SIZE]: pPageSize,
              [CURRENT_PAGE]: 1,
              [TOTAL_ITEMS]: result.totalItems,
              [TOTAL_PAGES]: result.totalPages,
              [LIST_DATA]: result.resultSearch,
            }
          })
        } catch (e) {
          await errorAlert('', NOTIFICATION_ERROR)
          console.error(e)
        } finally {
          this[SHOW_LOADING_A](false)
        }
      }
    },
    async onChangePage(page) {
      try {
        this[SHOW_LOADING_A](true)
        let dataSelect = {
          ...this.formDataSearch,
          'sortType': this.sortOrder,
          'sortColumn': this.sortColumn,
          'currentPage': page,
          'limit': this.pageSize
        }
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSelect);
        this[AC_CHANGE_DATATABLES]({
          type: UPDATE_STATE,
          payload: {
            [CURRENT_PAGE]: page,
            [LIST_DATA]: result.resultSearch,
          }
        });
        console.log('Change current page successful');
      } catch (error) {
        console.error('Error changing current page:', error);
        await errorAlert('', NOTIFICATION_ERROR)
      } finally {
        this[SHOW_LOADING_A](false)
      }
    },
    async onRelativePage(value) {
      let delivery = await loadDelivery(value.delivery_cd)
      if(Number(delivery?.del_flg) === 0) {
        await setLocalStorage(DELIVERY_DETAIL, delivery)
        this.$router.push({name: "delivery-detail"});
      } else {
        await errorAlert('', NOTIFICATION_ERROR)
      }
    },
    async onSortable(column) {
      try {
        if (column === this.sortColumn) {
          let tSort = this.sortOrder === ASC ? DESC : ASC
          this.uploadDatable({
            [SORT_ORDER]: tSort
          })
        } else {
          this.uploadDatable({
            [SORT_COLUMN]: column,
            [SORT_ORDER]: ASC
          })
        }
        let dataSort = {
          ...this.formDataSearch,
          'sortType': this.sortOrder,
          'sortColumn': this.sortColumn,
          'currentPage': this.currentPage,
          'limit': this.pageSize
        }
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSort);
        this.uploadDatable({
          [LIST_DATA]: result.resultSearch
        })
      } catch (e) {
        console.error(e)
        await errorAlert('', NOTIFICATION_ERROR)
      }
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
      totalItems: state => state.totalItems,
      startPage: state => state.startPage,
    }),
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    ...mapLoadingState({
      showLoading: state => state.showLoading
    })
  },
  setup() {
    let headers = searchTable.headers;
    let fields = searchTable.fields;
    return {
      headers,
      fields,
      keyItem: 'delivery_cd'
    }
  },
  data() {
    let selectOptions = selectOptionPageSize
    return {
      selectOptions
    };
  },
}

</script>

<style scoped>
</style>
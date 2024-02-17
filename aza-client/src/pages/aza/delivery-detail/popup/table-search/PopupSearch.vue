<script>

import FormSearch from "../../../delivery-search/form/FormSearch.vue";
import DataTables from "../../../delivery-search/data-tables/DataTables.vue";
import {SHOW_LOADING_A} from "../../../../../store/modules/loading-spinner/types.js";
import {postData} from "../../../delivery-search/service/HandleAPI.js";
import {
  AC_CHANGE_DATATABLES,
  CURRENT_PAGE, LIST_DATA,
  TOTAL_ITEMS, TOTAL_PAGES,
  UPDATE_STATE
} from "../../../../../store/modules/data-table/types.js";
import {notificationError} from "../../../../../helpers/notification.js";
import {NOTIFICATION_ERROR} from "../../../../../constants/notification.js";
import {createNamespacedHelpers} from "vuex";
import {ON_RESET_FORM_DATA} from "../../../../../store/modules/delivery-search/search-from/types.js";
const {
  mapState: mapDatableState,
  mapActions: mapDatatableActions
} = createNamespacedHelpers('dataTable');
const {
  mapState: mapFormDataSearchState,
  mapActions: mapFormDataSearchActions
} = createNamespacedHelpers('formDataSearch');

const {
  mapState: mapLoadingState,
  mapActions: mapLoadingActions
} = createNamespacedHelpers('loadingSpinner');
export default {
  components: {
    FormSearch,
    DataTables
  },
  methods: {
    ...mapDatatableActions([
      AC_CHANGE_DATATABLES
    ]),
    ...mapFormDataSearchActions([
      ON_RESET_FORM_DATA
    ]),
    ...mapLoadingActions([
      SHOW_LOADING_A
    ]),
    async handleSearch() {
      try {
        this[SHOW_LOADING_A](true)
        let data = this.createDataObject('search');
        let result = await postData(import.meta.env.VITE_APP_API_SEARCH, data);

        this[AC_CHANGE_DATATABLES]({
          type: UPDATE_STATE,
          payload: {
            [CURRENT_PAGE]: 1,
            [TOTAL_ITEMS]: result.totalItems,
            [TOTAL_PAGES]: result.totalPages,
            [LIST_DATA]: result.resultSearch,
          }
        })
      } catch (e) {
        notificationError(NOTIFICATION_ERROR)
        console.error(e)
      } finally {
        this[SHOW_LOADING_A](false)
      }

    },
    createDataObject(type) {
      switch (type) {
        case 'search':
          return {
            ...this.formDataSearch,
            'sortType': this.sortOrder,
            'sortColumn': this.sortColumn,
            'currentPage': this.currentPage,
            'limit': this.pageSize
          };
        case 'excel':
          return this.formDataSearch;
      }
    },
    handleResetSearch() {
      this[ON_RESET_FORM_DATA]()
      this[AC_CHANGE_DATATABLES]({type: RESET_STATE, payload: null})
    }
  },
  computed: {
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    }),
    ...mapDatableState({
      sortOrder: state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      currentPage: state => state.currentPage,
      pageSize: state => state.pageSize,
      listData: state => state.listData
    }),
    ...mapLoadingState({
      showLoading: state => state.showLoading
    })
  },
}
</script>

<template>
  <div class="modal fade" id="searchModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="searchLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered d-flex align-items-center justify-content-center">
      <div class="modal-content ">
        <div class="modal-header">
          <button type="button"
                  class="btn-close"
                  data-bs-dismiss="modal" aria-label="Close">

          </button>
        </div>
        <div class="modal-body">
          <FormSearch/>
            <div class="toolbar-bottom">
              <div class="toolbar-bottom-left">
              </div>
              <div class="toolbar-bottom-right">
                <button class="btn" @click="handleSearch" tabindex="104">
                  <font-awesome-icon :icon="['fas', 'magnifying-glass']" />
                </button>
              </div>
            </div>
          <DataTables/>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import "css/css.css";
</style>
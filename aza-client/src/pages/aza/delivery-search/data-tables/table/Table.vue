<script>
import {createNamespacedHelpers} from "vuex";
import {
  AC_CHANGE_DATATABLES,
  LIST_DATA,
  SORT_COLUMN,
  SORT_ORDER,
  UPDATE_STATE
} from "../../../../../store/modules/data-table/types.js";
import {postData} from "../../service/HandleAPI.js";

const {mapState: mapDatableState, mapActions: mapDatatableActions} = createNamespacedHelpers('dataTable');
const { mapState: mapFormDataSearchState, mapActions: mapFormDataSearchActions } = createNamespacedHelpers('formDataSearch');

export default {
  props: {
    columns: Array
  },
  methods: {
    ...mapDatatableActions([
        AC_CHANGE_DATATABLES
    ]),
    uploadDatable(payload) {
      this[AC_CHANGE_DATATABLES]({
        type: UPDATE_STATE,
        payload
      })
    },
    async onSortColumn(column) {
      if(this.totalPages === 0) {
        alert('Cannot Data Sort')
        return;
      }
      if (column === this.sortColumn) {
        let tSort = this.sortOrder === 'ASC' ? 'DESC' : 'ASC'
        this.uploadDatable({
          [SORT_ORDER]    : tSort
        })
      } else {
        this.uploadDatable( {
          [SORT_COLUMN]    : column,
          [SORT_ORDER]     : 'ASC'
        })
      }
      let dataSort = {
        ...this.formDataSearch,
        'sortType'    : this.sortOrder,
        'sortColumn'  : this.sortColumn,
        'currentPage' : this.currentPage,
        'limit'       : this.pageSize
      }
      let result = await postData(import.meta.env.VITE_APP_API_SEARCH, dataSort);
      this.uploadDatable({
        [LIST_DATA]: result.resultSearch
      })
    },
    onCheckSort(column) {
      let sortType = {
        'ASC': ['fas', 'sort-up'],
        'DESC': ['fas', 'sort-down'],
        'DEFAULT': ['fas', 'sort']
      }
      return column === this.sortColumn ?
          sortType[this.sortOrder]
          : sortType['DEFAULT']
    }
  },
  computed: {
    ...mapDatableState({
      sortOrder:    state => state.sortOrder,
      sortColumn:   state => state.sortColumn,
      currentPage:  state => state.currentPage,
      pageSize:     state => state.pageSize,
      totalPages:   state => state.totalPages,
      startPage:    state => state.startPage,
      listData: state => state.listData
    }),
    ...mapFormDataSearchState({
      formDataSearch: state => state.formData
    })
  },
  setup(props) {

    return {}
  }
}
</script>

<template>
  <div class="tbl-container">
    <table id="tbl-table" class="table table-bordered table-striped-custom" >
      <thead>
        <tr>
          <th v-for="col in columns" scope="col" class="tbl-header">
            <div class="tbl-header-box">
              <span></span>
              <span class="text-center">{{ col.title }}</span>
              <font-awesome-icon :icon="onCheckSort(col.column)" class="fws-icon"
                                 @click="onSortColumn(col.column)"/>
            </div>
          </th>
      </tr>
      </thead>
      <tbody>
      <tr v-if="listData.length === 0">
        <td colspan="8" class="text-center dataTables_empty" data-original-title="">&nbsp;</td>
      </tr>
    
      <tr v-else v-for="data in listData" class="text-center">
        <td>{{data.delivery_cd}}</td>
        <td>{{data.delivery_nm}}</td>
        <td>{{data.delivery_kn}}</td>
        <td>{{data.address}}</td>
        <td>{{data.tel}}</td>
        <td>{{data.delivery_class_1}}</td>
        <td>{{data.delivery_class_2}}</td>
        <td>{{data.delivery_class_3}}t</td>
      </tr>
      </tbody>
    </table>
  </div>

</template>

<style scoped>
@import 'css/css.css';
</style>
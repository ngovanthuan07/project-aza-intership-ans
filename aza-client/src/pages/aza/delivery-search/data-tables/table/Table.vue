<script>
import {createNamespacedHelpers} from "vuex";
import {
  AC_CHANGE_DATATABLES,
  LIST_DATA,
  SORT_COLUMN,
  SORT_ORDER
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
    async onSortColumn(column) {
      if(this.totalPages === 0) {
        alert('Cannot Data Sort')
        return;
      }
      if (column === this.sortColumn) {
        let tSort = this.sortOrder === 'ASC' ? 'DESC' : 'ASC'
         this[AC_CHANGE_DATATABLES]({
          type: SORT_ORDER,
          payload: tSort
        })
      } else {
         this[AC_CHANGE_DATATABLES]({
          type: SORT_COLUMN,
          payload: column
        })
         this[AC_CHANGE_DATATABLES]({
          type: SORT_ORDER,
          payload: 'ASC'
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
      this[AC_CHANGE_DATATABLES]({
        type: LIST_DATA,
        payload: result.resultSearch,
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
    }),
    filterDataSearch() {


      return data;

    }
  },
  setup(props) {

    return {}
  }
}
</script>

<template>

  <table id="table-data" class="table table-bordered table-striped-custom">
    <thead>
    <tr>
      <th v-for="col in columns" scope="col" class="table-header">
        <div class="table-header-box">
          <span></span>
          <span class="text-center">{{ col.title }}</span>
          <font-awesome-icon :icon="onCheckSort(col.column)" class="fws-icon"
                             @click="onSortColumn(col.column)"/>
        </div>
      </th>
    </tr>
    </thead>
    <tbody>
      <tr v-if="listData.length === 0" class="text-center">
        <td :colspan="columns.length">
          <div class="text-muted">No data available</div>
        </td>
      </tr>
      <tr v-else v-for="data in listData" class="text-center">
        <td>{{data.delivery_cd}}</td>
        <td>{{data.delivery_nm1 + data.delivery_nm2}}</td>
        <td>{{data.delivery_kn1 + data.delivery_kn1}}</td>
        <td>{{data.address}}</td>
        <td>{{data.tel}}</td>
        <td>{{data.lib_val_nm1_dc}}</td>
        <td>{{data.lib_val_nm2_dc}}</td>
        <td>{{data.lib_val_nm3_dc}}t</td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
@import 'css/css.css';
</style>
<script>
import {createNamespacedHelpers} from "vuex";
import {AC_CHANGE_DATATABLES, SORT_COLUMN, SORT_ORDER} from "../../../../../store/modules/data-table/types.js";

const {mapState: mapDatableState, mapActions: mapDatatableActions} = createNamespacedHelpers('dataTable');
const {mapState: mapSearchDataState, mapActions: mapSearchDataActions} = createNamespacedHelpers('dataSearch');

export default {
  props: {
    columns: Array
  },
  methods: {
    ...mapDatatableActions([
      [AC_CHANGE_DATATABLES]
    ]),
    async onSortColumn(column) {
      if (column === this.sortColumn) {
        let tSort = this.sortOrder === 'ASC' ? 'DESC' : 'ASC'
        await this[AC_CHANGE_DATATABLES]({
          type: SORT_ORDER,
          payload: tSort
        })
      } else {
        await this[AC_CHANGE_DATATABLES]({
          type: SORT_COLUMN,
          payload: column
        })
        await this[AC_CHANGE_DATATABLES]({
          type: SORT_COLUMN,
          payload: 'ASC'
        })
      }
      console.log('column: ' + this.sortColumn + ' sort:' + this.sortOrder)
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
      sortOrder: state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      pageSize: state => state.pageSize,
      currentPage: state => state.currentPage,
      listData: state => state.listData
    }),
    ...mapSearchDataState({
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
      <th v-for="col in columns">
        <div class="table-header-item">
          <span>{{ col.title }}</span>
          <font-awesome-icon :icon="onCheckSort(col.column)" class="table-header-icon"
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
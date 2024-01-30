<script>
import {createNamespacedHelpers} from "vuex";
import {AC_CHANGE_DATATABLES, SORT_COLUMN, SORT_ORDER} from "../../../../../store/modules/data-table/types.js";

const { mapState: mapDatableState, mapActions: mapDatatableActions } = createNamespacedHelpers('dataTable');
const { mapState: mapSearchDataState, mapActions: mapSearchDataActions } = createNamespacedHelpers('dataSearch');

export default {
  props: {
    columns: Array
  },
  methods: {
    ...mapDatatableActions([
       [AC_CHANGE_DATATABLES]
    ]),
    async onSortColumn(column) {
      if(column === this.sortColumn) {
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
          :  sortType['DEFAULT']

    }
  },
  computed:{
    ...mapDatableState({
      sortOrder: state => state.sortOrder,
      sortColumn: state => state.sortColumn,
      pageSize: state => state.pageSize,
      currentPage: state => state.currentPage,
    }),
    ...mapSearchDataState({
      datas: state => state.datas
    }),
    filterDataSearch() {


      return data;

    }
  },
  setup(props) {

    return {

    }
  }
}
</script>

<template>

  <table id="table-data" class="table table-bordered table-striped-custom">
    <thead>
      <tr>
        <th v-for="col in columns">
          <div class="table-header-item">
            <span>{{col.title}}</span>
            <font-awesome-icon :icon="onCheckSort(col.column)" class="table-header-icon" @click="onSortColumn(col.column)"/>
          </div>
        </th>

      </tr>
    </thead>
    <tbody>
      <tr v-for="data in 50" class="text-center">
        <td>Lorem ipsum</td>
        <td>Lorem ipsum dolor sit amet fdsf</td>
        <td>Lorem ipsum dolor sit amet fdsf</td>
        <td>Lorem jflsdkjflksdjkfjdslkfjljflkds</td>
        <td>7979797979</td>
        <td>Lorem ipsum dolor sit</td>
        <td>Lorem ipsum dolor sit</td>
        <td>Lorem ipsum dolor sit</td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
@import 'css/css.css';
</style>
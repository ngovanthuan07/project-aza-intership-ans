<script>
import {createNamespacedHelpers} from "vuex";
import {CHANGE_SORT_COLUMN, CHANGE_SORT_ORDER} from "../../../store/modules/data-table/types.js";

const { mapState: mapDatableState, mapActions: mapDatatableActions } = createNamespacedHelpers('dataTable');
const { mapState: mapSearchDataState, mapActions: mapSearchDataActions } = createNamespacedHelpers('dataSearch');

export default {
  props: {
    columns: Array
  },
  methods: {
    ...mapDatatableActions([
       CHANGE_SORT_COLUMN,
       CHANGE_SORT_ORDER
    ]),
    async onSortColumn(column) {
      if(column === this.sortColumn) {
        let tSort = this.sortOrder === 'ASC' ? 'DESC' : 'ASC'
        await this[CHANGE_SORT_ORDER](tSort)
      } else {
        await this[CHANGE_SORT_COLUMN](column)
        await this[CHANGE_SORT_ORDER]('ASC')
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
      let pageNumber = this.currentPage - 1;

      let data = this.datas.slice(pageNumber * this.pageSize, (pageNumber + 1) * this.pageSize);

      // const key = sortKey.value
      const cSort = this.sortColumn
      let order = this.sortOrder === 'ASC' ? 1 : -1;
      let key = ''
      switch (cSort) {
        case 'd4':
          key = 'delivery_cd'
              break;
        case 'd5':
          key = 'delivery_nm1'
            break;
        case'd6':
          key = 'delivery_kn1'
          break;
        case 'd7':
          key = 'delivery_kn1'
          break;
        case 'd8':
          key = 'lib_val_nm1'
          break;
        case'd9':
          key = 'lib_val_nm2'
          break;
        case'd10':
          key = 'lib_val_nm3'
          break;
      }

      if(key) {
        data = data.slice().sort((a, b) => {
          a = a[key]
          b = b[key]
          return (a === b ? 0 : a > b ? 1 : -1) * order
        })
      }

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
      <tr v-for="data in filterDataSearch" class="text-center">
        <td>{{ data.delivery_cd }}</td>
        <td>{{ data.delivery_nm1}}, {{ data.delivery_nm2}}</td>
        <td>{{ data.delivery_kn1}}, {{ data.delivery_kn2}}</td>
        <td>{{ data.lib_val_nm
          }}, {{ data.city_nm }}, {{ data.town_nm }}, {{data.apartment_nm}}</td>
        <td>{{ data.tel }}</td>
        <td>{{ data.lib_val_nm1 }}</td>
        <td>{{ data.lib_val_nm2 }}</td>
        <td>{{ data.lib_val_nm3 }}</td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
@import './css/css.css';
</style>
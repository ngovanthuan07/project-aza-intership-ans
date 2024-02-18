<script>

export default {
  props: {
    keyItem: undefined,
    headers: Array,
    fields: Array,
    items: Array,
    totalPages: Number,
    sortColumn: String,
    sortOrder: String,
    handleOnClickItem: Function,
    onSortable: Function
  },
  methods: {
    async onSortColumn(column) {
      this.onSortable(column)
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
    },
    handleDoubleClick(value) {
      this.handleOnClickItem(value)
    }
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
          <th v-for="header in headers" scope="col" class="tbl-header text-center" :class="header.class">
            <div v-if="this.totalPages > 0" class="tbl-header-box">
              <span></span>
              <span class="text-center">{{ header.title }}</span>
              <font-awesome-icon :icon="onCheckSort(header.column)" class="fws-icon"  @click="onSortColumn(header.column)"/>
            </div>
            <div>
              <div v-if="this.totalPages === 0" class="tbl-header-box">
                <span></span>
                <span class="text-center">{{ header.title }}</span>
                <span></span>
              </div>
            </div>
          </th>
      </tr>
      </thead>
      <tbody>
      <tr v-if="items.length === 0">
        <td :colspan="headers.length" class="text-center dataTables_empty" data-original-title="">&nbsp;</td>
      </tr>

      <tr
          v-else
          v-for="item in items"
          :key="item[keyItem]"
          @dblclick="handleDoubleClick(item)"
      >
        <td
            v-for="field in fields"
            :key="field">{{ item[field] }}
        </td>
      </tr>
      </tbody>
    </table>
  </div>

</template>

<style scoped>
@import 'css/css.css';
</style>
<template>
    <Pagination />
    <table id="tableSearch" class="table table-bordered custom-table">
        <thead class="table-secondary ">
            <tr>
                <th>納入先コード</th>
                <th>納入先名</th>
                <th>フリガナ</th>
                <th>住所</th>
                <th>電話番号</th>
                <th>納入先分類１</th>
                <th>納入先分類２</th>
                <th>納入先分類３</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>1</th>
                <td>Mark</td>
                <td>Otto</td>
                <td>@mdo</td>
                <td>@mdo</td>
                <td>@mdo</td>
                <td>@mdo</td>
                <td>@mdo</td>
            </tr>
            <tr>
                <th>1</th>
                <td>Mark</td>
                <td>Otto</td>
                <td>@mdo</td>
                <td>@mdo</td>
                <td>@mdo</td>
                <td>@mdo</td>
                <td>@mdo</td>
            </tr>
        </tbody>
    </table>
</template>
<script>
import { ref } from 'vue'

import Pagination from './Pagination.vue';

export default {
  components: {
    Pagination
  },
  setup() {
    // Your other logic goes here

    return {
   
    }
  }
}

</script>
<template>
    <div class="content-container ">
        <div class="content-header">
            <div class="content-header-left">
                <div class="content-header-item content-header-item-left">
                    納入先一覧
                </div>
            </div>
        </div>
        <div class="content">
          <div class="container-fluid">
            <div class="container-fluid">
              <FormSearch />

              <DataTables />
            </div>

          </div>

        </div>
    </div>
</template>
<style scoped>
@import "./css/css.css";
</style>
<script>
import DataTables from './data-tables/DataTables.vue';
import FormSearch from "./form/FormSearch.vue";

export default {
    components: {
      DataTables,
      FormSearch,
    },
    methods: {

    },
    computed: {


    },
    created() {

    }
}

</script>
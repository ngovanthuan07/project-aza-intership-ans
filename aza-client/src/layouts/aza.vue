<template>
    <div class="grow">
        <TheHeader />
        <div class="box-container col-12 d-flex">
            <Sidebar />
            <router-view></router-view>
        </div>

      <component :is="toolbarComponent"></component>
    </div>

</template>

<script>
import TheHeader from '../components/TheHeader.vue'
import Sidebar from '../components/Sidebar.vue'
import ToolbarBottomSearch from "../pages/aza/delivery-search/toolbar/ToolbarBottomSearch.vue";
import ToolbarBottomDetail from "../pages/aza/delivery-detail/toolbar/ToolbarBottomDetail.vue";


export default {
    components: {
        TheHeader,
        Sidebar,
        ToolbarBottomSearch,
        ToolbarBottomDetail
    },
    computed: {
      toolbarComponent() {
        switch (this.$route.name) {
          case 'delivery-search':
            return 'ToolbarBottomSearch';
          case 'delivery-detail':
            return 'ToolbarBottomDetail';
        }
      }
    }
}

</script>
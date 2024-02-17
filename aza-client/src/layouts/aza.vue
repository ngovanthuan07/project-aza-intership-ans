<template>
    <div class="wrapper">
      <Spinner v-if="this.showLoading"/>
      <TheHeader />
        <div class="content-wrapper col-12 d-flex">
            <Sidebar />
            <router-view></router-view>
        </div>

      <component :is="toolbarComponent"></component>
    </div>

</template>
<style>
@import "../assets/css/aza.css";
@import "../assets/css/popup-sweet-alert2.css";
</style>
<script>
import TheHeader from '../components/TheHeader.vue'
import Sidebar from '../components/Sidebar.vue'
import ToolbarBottomSearch from "../pages/aza/delivery-search/toolbar/ToolbarBottomSearch.vue";
import ToolbarBottomDetail from "../pages/aza/delivery-detail/toolbar/ToolbarBottomDetail.vue";
import Spinner from "../components/Spinner.vue";
import {createNamespacedHelpers} from "vuex";
import {SHOW_LOADING_A} from "../store/modules/loading-spinner/types.js";
const {
  mapState: mapLoadingState,
  mapActions: mapLoadingActions
} = createNamespacedHelpers('loadingSpinner');


export default {
    components: {
        TheHeader,
        Sidebar,
        ToolbarBottomSearch,
        ToolbarBottomDetail,
        Spinner
    },
    methods: {
      ...mapLoadingActions([
          SHOW_LOADING_A
      ])
    },
    computed: {
      toolbarComponent() {
        switch (this.$route.name) {
          case 'delivery-search':
            return 'ToolbarBottomSearch';
          case 'delivery-detail':
            return 'ToolbarBottomDetail';
        }
      },
      ...mapLoadingState({
        showLoading: state => state.showLoading
      })
    },
    mounted() {
      this[SHOW_LOADING_A](true)
      setTimeout(() => {
        this[SHOW_LOADING_A](false)
      }, 300);
    },
}
</script>

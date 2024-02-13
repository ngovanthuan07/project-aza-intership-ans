<template>
    <div class="content-container ">
        <div class="content-header">
            <div class="content-header-left">
                <div class="content-header-item content-header-item-left">
                    納入先マスター
                </div>
            </div>
            <div class="content-header-right">
                <div class="content-header-right">
                    <div class="content-header-item content-header-item-right">検索条件</div>
                    <div class="content-header-item content-header-item-right">納入先コード</div>
                    <div class="content-header-item content-header-item-right">納入先名</div>
                </div>
            </div>
        </div>
        <div class="content">
            <div class="container-fluid">
               <FormDetail />
            </div>
        </div>
    </div>
</template>
<style scoped>
@import "./css/css.css";
</style>
<script>
import FormDetail from './form/FormDetail.vue'
import {getData, postData} from "./service/HandleAPI.js";
  export default {
    components: {
      FormDetail
    },
    methods: {
      async loadDelivery(delivery_cd) {
        try {
          let result = await postData(import.meta.env.VITE_APP_API_GET_DELIVERY_BY_CD, {delivery_cd});
          if(result?.delivery) {
            return result.delivery
          }
        } catch (e) {
          console.error(e)
          return null;
        }
        return null
      }
    },
    async  mounted() {
      let id = null;
      if (this.$route.query?.delivery_cd) {
        id = await this.$route.query?.delivery_cd;
        this.delivery = await this.loadDelivery(id)
      }
    },
    data() {
      return {
        delivery: null
      }
    }
  }
</script>
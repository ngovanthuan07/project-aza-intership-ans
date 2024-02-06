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
  export default {
    components: {
      FormDetail
    }
  }
</script>
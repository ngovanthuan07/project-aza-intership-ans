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
        <FormDetail
            :handleOpenPopUp="onOpenPopUp"
        />
      </div>
    </div>
    <PopupSearch
        :togglePopup="togglePopup"
        :handlePopUp="handlePopUpTable"
        :handleClosePopUp="onClosePopUp"
    />

  </div>
</template>
<style scoped>
@import "./css/css.css";
</style>
<script>
import FormDetail from './form/FormDetail.vue'
import {postData} from "./service/HandleAPI.js";
import {createNamespacedHelpers} from "vuex";
import {CHANGE_OPTION, EDIT, NEW, UPDATE_FORM_DATA_DETAIL_A} from "../../../store/modules/request-form/types.js";
import {getLocalStorage, setLocalStorage} from "../../../common/client-side-storage/clientStorage.js";
import {DELIVERY_DETAIL} from "../../../constants/clientConstant.js";
import PopupSearch from "./popup/table-search/PopupSearch.vue";
import {mapAddDetail} from "./map/detail.js";

const {
  mapActions: mapFormDataDetailActions
} = createNamespacedHelpers('requestForm');

export default {
  components: {
    PopupSearch,
    FormDetail
  },
  methods: {
    ...mapFormDataDetailActions([
      UPDATE_FORM_DATA_DETAIL_A
    ]),
    async loadDelivery(delivery_cd) {
      try {
        let result = await postData(import.meta.env.VITE_APP_API_GET_DELIVERY_BY_CD, {delivery_cd});
        if (result?.delivery) {
          return result.delivery
        }
      } catch (e) {
        console.error(e)
        return null;
      }
      return null
    },
    async handlePopUpTable(value) {
      await setLocalStorage(DELIVERY_DETAIL, value)
      this.deliveryDetailClient = value
    },
    onOpenPopUp() {
      this.togglePopup = true
    },
    onClosePopUp() {
      this.togglePopup = false
    }
  },
  async mounted() {
    this.deliveryDetailClient = null;
    if (getLocalStorage(DELIVERY_DETAIL)) {
      this.deliveryDetailClient = await getLocalStorage(DELIVERY_DETAIL);
      let delivery = await this.loadDelivery(this.deliveryDetailClient.delivery_cd)
      this[UPDATE_FORM_DATA_DETAIL_A]({action: '', payload: delivery})
      await this[UPDATE_FORM_DATA_DETAIL_A]({action: {
        type: CHANGE_OPTION, payload: EDIT
      }})
    } else {
      let delivery = mapAddDetail({})
      this[UPDATE_FORM_DATA_DETAIL_A]({action: '', payload: delivery})
      await this[UPDATE_FORM_DATA_DETAIL_A]({action: CHANGE_OPTION, payload: NEW})
    }

  },
  watch: {
    // 'deliveryDetailClient': async function (newDeliveryDetailClient, oldDeliveryDetailClient) {
    //   if (newDeliveryDetailClient !== oldDeliveryDetailClient) {
    //     let delivery = await this.loadDelivery(newDeliveryDetailClient.delivery_cd);
    //     this[UPDATE_FORM_DATA_DETAIL_A]({action: '', payload: delivery})
    //   }
    // },
  },
  data() {
    return {
      deliveryDetailClient: null,
      togglePopup: false
    }
  }
}
</script>
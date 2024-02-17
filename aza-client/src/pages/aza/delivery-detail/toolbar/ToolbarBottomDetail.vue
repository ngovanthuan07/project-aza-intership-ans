<script>
import {createNamespacedHelpers} from "vuex";
import {UPDATE_FORM_DATA_DETAIL_A} from "../../../../store/modules/request-form/types.js";
import {postData} from "../../delivery-search/service/HandleAPI.js";
import {notificationError} from "../../../../helpers/notification.js";
import {NOTIFICATION_ERROR} from "../../../../constants/notification.js";
import {mapUpdateDetail} from "../map/detail.js";
import {
  DETAIL_QUESTION_REGISTER,
  DETAIL_UPDATE_FAIL,
  DETAIL_UPDATE_SUCCESSFUL
} from "../../../../constants/alertConstant.js";
import {errorAlert, infoAlert, questionAlert} from "../../../../common/modal/popupSwal.js";

const {
  mapState: mapFormDataDetailState,
  mapActions: mapFormDataDetailActions
} = createNamespacedHelpers('requestForm');
export default {
  components: {

  },
  methods: {
    ...mapFormDataDetailActions([
      UPDATE_FORM_DATA_DETAIL_A
    ]),
    handleBack() {
      this.$router.back();
    },
    onDelete() {
      console.log('handle delete')
    },
    onCopy() {
      console.log('handle copy')
    },
    onNew() {
      console.log('handle new')
    },
    async onRegister() {
      try {
        let confirmUpdate = await questionAlert('[C007]',DETAIL_QUESTION_REGISTER)
        if(confirmUpdate) {
          let data = await mapUpdateDetail(this.formData);
          let result = await postData(import.meta.env.VITE_APP_API_DETAIL_UPDATE, data);

          await infoAlert('[I001]', DETAIL_UPDATE_SUCCESSFUL)
        }
      } catch (e) {
        console.error('Error download file:', e);
        await errorAlert('[C007]', DETAIL_UPDATE_FAIL)
      } finally {
      }
    }
  },
  computed: {
    ...mapFormDataDetailState({
      formData: state => state.deliveryDetail.formData
    })
  },
  data() {
    return {

    };
  }
}

</script>

<template>
  <div class="toolbar-bottom">
    <div class="toolbar-bottom-left">
      <button type="button" class="btn btn-back" @click="handleBack" tabindex="105">
        <font-awesome-icon :icon="['fas', 'caret-left']" /> 戻る
      </button>
    </div>
    <div class="toolbar-bottom-right">
      <button class="btn btn-delete" @click="onDelete" tabindex="101">
        削除
      </button>
      <button class="btn btn-copy" @click="onCopy" tabindex="102">
        複写
      </button>
      <button class="btn btn-new" @click="onNew" tabindex="103">
        新規
      </button>
      <button class="btn btn-register" @click="onRegister" tabindex="104">
        登録
      </button>
    </div>
  </div>
</template>

<style scoped>
@import './css/css.css';
</style>
<script>
import {createNamespacedHelpers} from "vuex";
import {
  CHANGE_ERROR_MESSAGE,
  CHANGE_OPTION,
  EDIT,
  NEW,
  UPDATE_FORM_DATA_DETAIL_A
} from "../../../../store/modules/request-form/types.js";
import {postData} from "../../delivery-search/service/HandleAPI.js";
import {notificationError} from "../../../../helpers/notification.js";
import {NOTIFICATION_ERROR} from "../../../../constants/notification.js";
import {mapAddDetail, mapUpdateDetail, resetData} from "../map/detail.js";
import {
  DETAIL_COPY, DETAIL_DELETE,
  DETAIL_MODE_EDIT, DETAIL_NEW,
  DETAIL_QUESTION_REGISTER,
  DETAIL_UPDATE_FAIL,
  DETAIL_UPDATE_SUCCESSFUL
} from "../../../../constants/alertConstant.js";
import {errorAlert, infoAlert, questionAlert} from "../../../../common/modal/popupSwal.js";
import {DELIVERY_DETAIL} from "../../../../constants/clientConstant.js";
import {
  setLocalStorage,
  removeLocalStorage,
  getLocalStorage
} from "../../../../common/client-side-storage/clientStorage.js";
import {hasNonNullValue} from "../../../../helpers/object-helper.js";
import loadDelivery from "../service/deliveryLoadData.js";
import {ValidateFormData} from "../../../../common/validation/validation.js";
import {rules, messages} from "../request/formDetailRequest.js";

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
    async onDelete() {
      let confirmDelete = await questionAlert('[C007]',DETAIL_DELETE)
      if(confirmDelete) {
        if(this.formData.delivery_cd) {
          let result = await postData(import.meta.env.VITE_APP_API_DETAIL_REMOVE, {
              'delivery_cd': this.formData.delivery_cd,
              'del_user': 'me',
              'del_prg': null,
              'del_ip': null,
              'del_date': null,

        });
          if(result?.data) {
            if(result?.data.result === '1') {
              await infoAlert('[I001]', DETAIL_UPDATE_SUCCESSFUL)
              await this.onNew()
            } else {
              await errorAlert('[C007]', DETAIL_UPDATE_FAIL)
            }
          }


        } else {
          await errorAlert('[C007]', DETAIL_UPDATE_FAIL)
        }
      }

    },
    async onCopy() {
      let confirmCopy = await questionAlert('[C007]',DETAIL_COPY)
      if(confirmCopy) {
        await removeLocalStorage(DELIVERY_DETAIL)
        await this[UPDATE_FORM_DATA_DETAIL_A]({action: '', payload: {delivery_cd: null}})
        await this[UPDATE_FORM_DATA_DETAIL_A]({
          type: CHANGE_OPTION, payload: NEW
        })
      }
    },
    async onNew() {
      // let confirmNew = await questionAlert('[C007]',DETAIL_NEW)
      // if(confirmNew) {
        let delivery = resetData({})
        await removeLocalStorage(DELIVERY_DETAIL)
        await this[UPDATE_FORM_DATA_DETAIL_A]({action: '', payload: delivery})
        await this[UPDATE_FORM_DATA_DETAIL_A]({
          type: CHANGE_OPTION, payload: NEW
        })
      // }
    },
    async onRegister() {
      try {
        let [errorMessages, isValid] = ValidateFormData({
          'formData': this.formData,
          'rules': rules,
          'messages': messages
        });
        if(isValid) {
          this[UPDATE_FORM_DATA_DETAIL_A]({
            type: CHANGE_ERROR_MESSAGE,
            payload: errorMessages
          })
          await errorAlert('[C007]', DETAIL_UPDATE_FAIL)
        } else {
          let confirmUpdate = await questionAlert('[C007]',DETAIL_QUESTION_REGISTER)
          if(confirmUpdate) {
            let result;
            let data;
            if(this.option === EDIT) {
              data = await mapUpdateDetail(this.formData);
              result = await postData(import.meta.env.VITE_APP_API_DETAIL_UPDATE, data);
            } else {
              data = await mapAddDetail(this.formData);
              result = await postData(import.meta.env.VITE_APP_API_DETAIL_ADD, data);
            }
            await infoAlert('[I001]', DETAIL_UPDATE_SUCCESSFUL)

            if(result?.data) {
              let confirmModeEdit = await questionAlert('[C007]',DETAIL_MODE_EDIT)
              if(confirmModeEdit) {
                let delivery_cd = this.option === EDIT ? data.delivery_cd : result?.data.delivery_cd;
                let delivery = await loadDelivery(delivery_cd)
                await setLocalStorage(DELIVERY_DETAIL, delivery)
                await this[UPDATE_FORM_DATA_DETAIL_A]({action: '', payload: delivery})
                await this[UPDATE_FORM_DATA_DETAIL_A]({
                  type: CHANGE_OPTION, payload: EDIT
                })
              } else {
                await this.onNew()
              }
            } else {
              await errorAlert('[C007]', DETAIL_UPDATE_FAIL)
            }
          }
        }
      } catch (e) {
        console.error('Error download file:', e);
        await errorAlert('[C007]', DETAIL_UPDATE_FAIL)
      } finally {
      }
    },
    disabledBtn(btn) {
      switch (btn) {
        case 'delete': {
          if (this.option === EDIT) {
            return false;
          }
          break;
        }
        case 'copy': {
          if (this.option === EDIT) {
            return false;
          }
          break;
        }
        case 'register': {
          let isSomeNonNullValueFormData = hasNonNullValue(this.formData)
          if(isSomeNonNullValueFormData) {
            return false;
          }
          break;
        }
      }
      return true;
    }
  },
  computed: {
    ...mapFormDataDetailState({
      formData: state => state.deliveryDetail.formData,
      option: state => state.deliveryDetail.option,
      errors:   state => state.deliveryDetail.errorsMessages
    }),
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
      <button :disabled="disabledBtn('delete')"  class="btn btn-delete" @click="onDelete" tabindex="101">
        削除
      </button>
      <button :disabled="disabledBtn('copy')"   class="btn btn-copy" @click="onCopy" tabindex="102">
        複写
      </button>
      <button class="btn btn-new" @click="onNew" tabindex="103">
        新規
      </button>
      <button :disabled="disabledBtn('register')"  class="btn btn-register" @click="onRegister" tabindex="104">
        登録
      </button>
    </div>
  </div>
</template>

<style scoped>
@import './css/css.css';
</style>
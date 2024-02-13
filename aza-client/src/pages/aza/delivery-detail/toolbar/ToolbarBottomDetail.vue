<script>

export default {
  components: {

  },
  methods: {
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
    onRegister() {
      console.log('handle coppy')
    }
  },
  computed: {

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
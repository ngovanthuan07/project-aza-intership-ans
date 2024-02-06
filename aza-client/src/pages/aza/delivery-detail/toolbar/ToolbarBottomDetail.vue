<script>

export default {
  components: {

  },
  methods: {
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
      <button type="button" class="btn">
        <font-awesome-icon :icon="['fas', 'caret-left']" /> 戻る
      </button>
    </div>
    <div class="toolbar-bottom-right">
      <button class="btn btn-danger btnDelete" @click="onDelete">
        削除
      </button>
      <button class="btn" @click="onCopy">
        複写
      </button>
      <button class="btn" @click="onNew">
        新規
      </button>
      <button class="btn btn-primary btnRegister" @click="onRegister">
        登録
      </button>
    </div>
  </div>
</template>

<style scoped>
@import './css/css.css';
</style>
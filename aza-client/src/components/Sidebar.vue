<template>
  <div class="sidebar-container">
    <ul class="sidebar navbar-nav mr-auto">
      <!-- A -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'envelope']" class="sidebar-icon"/>
          <span class="sidebar-content">お知らせ</span>
        </button>
      </li>
      <!-- B -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'calendar-days']" class="sidebar-icon"/>
          <span class="sidebar-content">シフト</span>
        </button>
      </li>
      <!-- C -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'barcode']" class="sidebar-icon"/>
          <span class="sidebar-content">在庫</span>
        </button>
      </li>
      <!-- D -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'clipboard']" class="sidebar-icon"/>
          <span class="sidebar-content">ハンディ</span>
        </button>
      </li>
      <!-- E -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'chart-line']" class="sidebar-icon"/>
          <span class="sidebar-content">売上</span>
        </button>
      </li>
      <!-- F -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'box-open']" class="sidebar-icon"/>
          <span class="sidebar-content">仕入</span>
        </button>
      </li>
      <!-- G -->
      <li class="sidebar-item nav-item" :class="{ 'active': $route.name === 'delivery-search' }">
        <router-link @click="handleChangeRoute" :to="{ name: 'delivery-search' }" class="nav-link sidebar-router" href="#">
          <font-awesome-icon :icon="['fas', 'up-long']" class="sidebar-icon"/>
          <span class="sidebar-content">データ出力</span>
        </router-link>
      </li>
      <!-- H -->
      <li class="sidebar-item nav-item" :class="{ 'active': $route.name === 'delivery-detail' }">
        <router-link @click="handleChangeRoute"  :to="{ name: 'delivery-detail' }" class="nav-link sidebar-router" href="#">
          <font-awesome-icon :icon="['fas', 'star']"  class="sidebar-icon"/>
          <span class="sidebar-content">マスター</span>
        </router-link>

      </li>
      <!-- I -->
      <li class="sidebar-item nav-item">
        <button class="nav-link" href="#">
          <font-awesome-icon :icon="['fas', 'gear']" class="sidebar-icon"/>
          <span class="sidebar-content">設定</span>
        </button>
      </li>
    </ul>
  </div>
</template>
<style scoped>
@import "../assets/css/sidebar.css";
</style>
<script>

export default {
  data() {
    return {
      activeTab: null,
    };
  },
  methods: {
    handleChangeRoute() {

    },
    setActiveTab(tab) {
      this.activeTab = tab;
    },
  },
};
</script>
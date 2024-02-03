<script setup>

</script>

<template>
  <div class="spinner">
    <div class="text-center text-white">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.spinner {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(165, 167, 168, 0.5);
  position: fixed;
  top: 0px;
  left: 0px;
  z-index: 9999;
  opacity: 1;
}
.spinner-border {
  animation-duration: 0.7s;
}
</style>
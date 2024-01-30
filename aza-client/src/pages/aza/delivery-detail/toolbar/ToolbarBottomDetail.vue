<script>
import {createNamespacedHelpers} from "vuex";
import {CHANGE_BUTTONS} from "../../../../store/modules/buttons/types.js";
const { mapState: mapButtonsState, mapActions: mapButtonsActions } = createNamespacedHelpers('buttons');

  export default {
    components: {

    },
    methods: {
      ...mapButtonsActions([
        CHANGE_BUTTONS
      ])
    },
    computed: {
      ...mapButtonsState({
        buttons: state => state.buttons
      }),
      filteredButtonRight() {
        console.log(this.buttons)
        return this.buttons.filter(item => item.position === 'right')
      }
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
        <button type="button" class="btn btn-outline-primary"></button>
      </div>
      <div class="toolbar-bottom-right">
        <Buttons
            :buttons="filteredButtonRight"
        />
      </div>
  </div>
</template>

<style scoped>
.toolbar-bottom {
  width: 100%;
  height: 50px;
  background-color: #fff;
  border-top: 1px solid #fff;
  position: relative;
  bottom: 0;
  z-index: 1000;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}
</style>
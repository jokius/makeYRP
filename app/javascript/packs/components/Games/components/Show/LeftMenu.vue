<template>
  <div class="left-menu-actions">
    <cursor-button />
    <!--    <drawing-button />-->
    <layer-button />
    <dice-button />
  </div>
</template>

<script>
  import DiceButton from './leftMenuButtons/DiceButton'
  import LayerButton from './leftMenuButtons/LayerButton'
  import CursorButton from './leftMenuButtons/CursorButton'
  export default {
    name: 'LeftMenu',
    components: { CursorButton, LayerButton, DiceButton },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .left-menu-actions {
    position: absolute;
    z-index: 2;
    left: 10px;
    top: 70px;
    box-shadow: 0 0 10px rgba(0,0,0,0.5);
  }
</style>

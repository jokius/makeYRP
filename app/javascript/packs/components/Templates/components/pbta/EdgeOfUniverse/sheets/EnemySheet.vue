<template>
  <div class="sheet-body" :style="{ width, height }">
    <enemy-main-body :id="id" />
  </div>
</template>

<script>
  import EnemyMainBody from './EnemyMainBody'

  export default {
    name: 'EnemySheet',
    components: { EnemyMainBody },
    props: {
      id: { type: Number, required: true },
      size: { type: Object, required: true },
    },

    computed: {
      width: {
        get() {
          const width = this.size.width
          return typeof width === 'number' ? `${width}px` : width
        },
      },

      height: {
        get() {
          const height = this.size.height
          return typeof height === 'number' ? `${height}px` : height
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .sheet-body {
    background-color: $grayC5;
    overflow: auto;
  }
</style>

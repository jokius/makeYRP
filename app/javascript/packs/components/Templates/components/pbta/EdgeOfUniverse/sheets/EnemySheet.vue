<template>
  <div v-if="canWrite" class="sheet-body" :style="{ width, height }">
    <enemy-main-body :id="id" />
  </div>
  <div v-else class="sheet-body" :style="{ width, height }">
    <character-read-only :id="id" />
  </div>
</template>

<script>
  import EnemyMainBody from './EnemyMainBody'
  import CharacterReadOnly from './CharacterReadOnly'

  export default {
    name: 'EnemySheet',
    components: { CharacterReadOnly, EnemyMainBody },
    props: {
      id: { type: Number, required: true },
      size: { type: Object, required: true },
    },

    computed: {
      canWrite: {
        get() {
          return this.sheet.acl.canWrite
        },
      },

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

<template>
  <div class="sheet-body" :style="{ width, height }">
    <v-tabs
      v-model="tab"
      color="basil"
      grow
      height="30"
    >
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Основные параметры</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Описание и отношения</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items v-model="tab" continuous>
      <v-tab-item>
        <main-body :id="id" />
      </v-tab-item>
      <v-tab-item>
        <character-info :id="id" />
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
  import MainBody from './MainBody'
  import CharacterInfo from './CharacterInfo'

  export default {
    name: 'MutantSheet',
    components: { CharacterInfo, MainBody },
    props: {
      id: { type: Number, required: true },
      size: { type: Object, required: true },
    },

    data() {
      return {
        tab: null,
      }
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
  @import '~assets/css/colors';

  .sheet-body {
    background-color: $grayC5;
    overflow: auto;
  }

  .tab {
    background-color: $orangeE9;
  }

  .tab-active {
    background-color: $white;
  }
</style>

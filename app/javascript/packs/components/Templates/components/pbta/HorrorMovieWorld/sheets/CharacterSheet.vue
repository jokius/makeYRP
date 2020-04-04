<template>
  <div class="sheet-body" :style="{ width, height }">
    <v-tabs
      v-model="tab"
      color="basil"
      grow
      height="30"
    >
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">О персанаже</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Ходы</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Отнашения</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items v-model="tab" continuous>
      <v-tab-item>
        <character-main-body :id="id" />
      </v-tab-item>
      <v-tab-item>
        <character-move-body :id="id" />
      </v-tab-item>
      <v-tab-item>
        <character-relationship-body :id="id" />
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
  import CharacterMainBody from './CharacterMainBody'
  import CharacterMoveBody from './CharacterMoveBody'
  import CharacterRelationshipBody from './CharacterRelationshipBody'

  export default {
    name: 'CharacterSheet',
    components: { CharacterRelationshipBody, CharacterMoveBody, CharacterMainBody },
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
  @import 'app/javascript/packs/components/ui/css/colors';

  .sheet-body {
    background-color: $grayC5;
    overflow: auto;
  }

  .tab {
    background-color: $gray52;
  }

  .tab-active {
    background-color: $white;
  }
</style>

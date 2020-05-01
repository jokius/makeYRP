<template>
  <div v-if="canWrite" class="sheet-body" :style="{ width, height }">
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
      <v-tab v-for="item in specialTabs" :key="`tabs-${item.index}`" class="tab" active-class="tab-active">
        <span class="xolonium-font">{{ item.tab.name }}</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Снаряжение</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Отношения</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items v-model="tab" continuous>
      <v-tab-item>
        <character-main-body :id="id" />
      </v-tab-item>
      <v-tab-item>
        <character-move-body :id="id" />
      </v-tab-item>
      <v-tab-item v-for="item in specialTabs" :key="`tab-item-${item.index}`">
        <tab-special :id="id" :special="item.tab" :special-index="item.index" />
      </v-tab-item>
      <v-tab-item>
        <character-equipment-body :id="id" />
      </v-tab-item>
      <v-tab-item>
        <character-relationship-body :id="id" />
      </v-tab-item>
    </v-tabs-items>
  </div>
  <div v-else class="sheet-body" :style="{ width, height }">
    <character-read-only :id="id" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import CharacterMainBody from './CharacterMainBody'
  import CharacterMoveBody from './CharacterMoveBody'
  import CharacterRelationshipBody from './CharacterRelationshipBody'
  import CharacterEquipmentBody from './CharacterEquipmentBody'
  import TabSpecial from './TabSpecial'
  import CharacterReadOnly from './CharacterReadOnly'

  export default {
    name: 'CharacterSheet',
    components: {
      CharacterReadOnly,
      TabSpecial,
      CharacterEquipmentBody,
      CharacterRelationshipBody,
      CharacterMoveBody,
      CharacterMainBody,
    },
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
      ...mapState({
        sheets: state => state.game.sheets,
        specialTabs: state => state.game.specialTabs,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

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

  .tab {
    background-color: $gray52;
  }

  .tab-active {
    background-color: $white;
  }
</style>

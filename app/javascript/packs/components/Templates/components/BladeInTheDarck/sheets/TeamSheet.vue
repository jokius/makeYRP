<template>
  <div class="sheet-body" :style="{ width, height }">
    <v-tabs
      v-model="tab"
      color="basil"
      grow
      height="30"
    >
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">О команде</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Навыки и снаряжение</span>
      </v-tab>
      <v-tab class="tab" active-class="tab-active">
        <span class="xolonium-font">Тюрьма</span>
      </v-tab>
    </v-tabs>

    <v-tabs-items v-model="tab" continuous>
      <v-tab-item>
        <team-main-body :id="id" />
      </v-tab-item>
      <v-tab-item>
        <!--<skill-body :id="id" />-->
      </v-tab-item>
      <v-tab-item>
        <prison-body :id="id" />
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
  import TeamMainBody from './TeamMainBody'
  import PrisonBody from './PrisonBody'

  export default {
    name: 'TeamSheet',
    components: { PrisonBody, TeamMainBody },
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

<template>
  <vue-draggable-resizable
    drag-handle=".drag-handle"
    :w="width"
    :h="height"
    :x="xPoint"
    :y="yPoint"
    :z="zModal"
    :resizable="resizable"
    :active="resizable"
    class-name-active="resize-boards"
  >
    <v-card>
      <v-toolbar dark color="indigo" class="header drag-handle">
        <v-toolbar-title>{{ title }}</v-toolbar-title>
        <v-spacer />
        <v-btn icon dark @click="onClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <div :style="{ width, height, overflow: 'auto' }">
        <slot name="body" />
        <v-divider />
        <v-card-actions v-if="hasActionsSlot">
          <slot name="actions" />
        </v-card-actions>
      </div>
    </v-card>
  </vue-draggable-resizable>
</template>

<script>
  import { mapState } from 'vuex'
  import VueDraggableResizable from 'vue-draggable-resizable'
  import 'vue-draggable-resizable/dist/VueDraggableResizable.css'

  export default {
    name: 'DraggableDialog',
    components: { VueDraggableResizable },
    props: {
      title: { type: String, required: true },
      onClose: { type: Function, required: true },
      width: { type: Number, default: 200 },
      height: { type: Number, default: 200 },
      resizable: { type: Boolean, default: false },
    },
    data() {
      return {
        xPoint: 0,
        yPoint: 0,
      }
    },
    computed: {
      ...mapState({
        openModals: (state) => state.game.openModals,
      }),

      zModal() {
        return 100 + this.openModals.length
      },

      hasActionsSlot: {
        get() {
          return !!this.$slots.actions
        },
      },
    },

    created() {
      window.addEventListener('resize', this.handleResize)
      this.handleResize();
    },

    destroyed() {
      window.removeEventListener('resize', this.handleResize)
    },

    methods: {
      handleResize() {
        this.xPoint = (window.innerWidth - this.width) / 2;
        this.yPoint = (window.innerHeight - this.height) / 2;
      },
    },
  }
</script>

<style scoped lang="scss">
  .header {
    cursor: move;
  }
</style>

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
    class-name-handle="draggable-dialog-handle"
    @resizing="onResize"
  >
    <v-card class="resize-style" :style="style">
      <v-toolbar dark color="indigo" class="draggable-dialog-header drag-handle">
        <v-toolbar-title>{{ title }}</v-toolbar-title>
        <v-spacer />
        <v-btn icon dark @click="onClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <slot name="body" />
      <v-divider />
      <v-card-actions v-if="hasActionsSlot">
        <slot name="actions" />
      </v-card-actions>
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

    model: {
      prop: 'size',
      event: 'onResize',
    },

    props: {
      title: { type: String, required: true },
      onClose: { type: Function, required: true },
      size: { type: Object, required: true },
      width: { type: Number, default: 200 },
      height: { type: Number, default: 200 },
      resizable: { type: Boolean, default: false },
    },

    data() {
      return {
        xPoint: 0,
        yPoint: 0,
        dataWidth: null,
        dataHeight: null,
      }
    },

    computed: {
      ...mapState({
        openModals: state => state.game.openModals,
      }),

      zModal() {
        return 100 + this.openModals.length
      },

      hasActionsSlot: {
        get() {
          return !!this.$slots.actions
        },
      },

      style: {
        get() {
          let width = this.dataWidth || this.width
          let height = this.dataHeight || this.height

          return { width: `${width}px`, height: `${height - 2}px`, overflow: 'auto' }
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

      onResize: function (_x, _y, width, height) {
        this.$emit('onResize', { width, height })
      },
    },
  }
</script>

<style lang="scss">
  .draggable-dialog-header {
    cursor: move;
  }

  .draggable-dialog-handle {
    position: absolute;
    background-color: black;
    height: 2px;
    width: 2px;
  }

  .draggable-dialog-handle-tl {
    cursor: nw-resize;
    top: -2px;
    left: -1px;
    width: 4px;
    height: 3px;
  }

  .draggable-dialog-handle-tm {
    cursor: n-resize;
    top: -2px;
    width: 100%;
  }

  .draggable-dialog-handle-tr {
    cursor: ne-resize;
    top: -2px;
    right: -1px;
    width: 4px;
    height: 3px;
  }

  .draggable-dialog-handle-mr {
    cursor: e-resize;
    height: 100%;
    right: -1px;
  }

  .draggable-dialog-handle-bl {
    cursor: sw-resize;
    bottom: -2px;
    left: -1px;
    width: 4px;
    height: 3px;
  }

  .draggable-dialog-handle-bm {
    cursor: s-resize;
    bottom: -2px;
    width: 100%;
  }

  .draggable-dialog-handle-ml {
    cursor: w-resize;
    height: 100%;
    left: -1px;
  }

  .draggable-dialog-handle-br {
    cursor: se-resize;
    bottom: -2px;
    right: -1px;
    width: 4px;
    height: 3px;
  }
</style>

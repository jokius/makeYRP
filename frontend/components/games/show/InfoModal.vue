<template>
  <draggable-dialog
    :on-close="onClose"
    :title="title"
    :width="600"
    :height="500"
    resizable
  >
    <template v-slot:body>
      <v-container class="fill-height" fluid>
        <div v-html="description" />
      </v-container>
    </template>
  </draggable-dialog>
</template>

<script>


  import DraggableDialog from './DraggableDialog'

  export default {
    name: 'InfoModal',
    components: { DraggableDialog },

    props: {
      uniqKey: { type: Number, required: true },
      title: { type: String, required: true },
      description: { type: String, required: true },
    },

    methods: {
      onClose() {
        this.$store.commit('game/removeOpenModal', this.uniqKey)
      },
    },
  }
</script>

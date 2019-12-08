<template>
  <draggable-dialog :on-close="onClose" :title="title" :width="600" :height="500">
    <template v-slot:body>
      <v-container class="fill-height" fluid>
        <div v-html="description" />
      </v-container>
    </template>
  </draggable-dialog>
</template>

<script>


  import DraggableDialog from './DraggableDialog'

  import { REMOVE_OPEN_MODAL } from '../../stores/mutation-types'

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
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
      },
    },
  }
</script>

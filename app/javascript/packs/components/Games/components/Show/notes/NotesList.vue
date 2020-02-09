<template>
  <v-list>
    <note-item
      v-for="note in list"
      :key="note.id"
      :note="note"
    />
  </v-list>
</template>

<script>

  import NoteItem from './NoteItem'
  export default {
    name: 'NotesList',
    components: { NoteItem },
    props: {
      list: { type: Array, required: true },
    },
  }
</script>

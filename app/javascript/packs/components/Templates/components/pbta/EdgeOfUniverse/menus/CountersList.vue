<template>
  <v-list>
    <counter-item
      v-for="counter in list"
      :key="counter.id"
      :clock="counter"
    />
  </v-list>
</template>

<script>
  import CounterItem from './CounterItem'

  export default {
    name: 'CountersList',
    components: { CounterItem },

    props: {
      list: { type: Array, required: true },
    },
  }
</script>

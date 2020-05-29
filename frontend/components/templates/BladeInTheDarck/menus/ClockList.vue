<template>
  <v-list>
    <clock-item
      v-for="clock in list"
      :key="clock.id"
      :clock="clock"
    />
  </v-list>
</template>

<script>
  import ClockItem from './ClockItem'

  export default {
    name: 'ClockList',
    components: { ClockItem },

    props: {
      list: { type: Array, required: true },
    },
  }
</script>

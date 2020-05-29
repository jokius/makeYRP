<template>
  <v-list>
    <planet-item
      v-for="planet in list"
      :key="planet.id"
      :planet="planet"
    />
  </v-list>
</template>

<script>
  import PlanetItem from './PlanetItem'

  export default {
    name: 'PlanetsList',
    components: { PlanetItem },

    props: {
      list: { type: Array, required: true },
    },
  }
</script>

<template>
  <v-list-item class="planet-item-grid">
    <span>{{ name }}</span>
    <v-btn
      fab
      x-small
      dark
      @click="viewPlanet"
    >
      <v-icon>mdi-eye-outline</v-icon>
    </v-btn>
    <v-btn
      fab
      x-small
      dark
      @click="editPlanet"
    >
      <v-icon>mdi-pencil</v-icon>
    </v-btn>
    <v-btn
      color="red darken-4"
      fab
      x-small
      dark
      @click="deletePlanet"
    >
      <v-icon>mdi-delete</v-icon>
    </v-btn>
  </v-list-item>
</template>

<script>
  export default {
    name: 'PlanetItem',

    props: {
      planet: { type: Object, required: true },
    },

    computed: {
      name: {
        get() {
          return this.planet.params.name
        },
      },
    },

    methods: {
      viewPlanet() {
        this.showModal(false)
      },

      editPlanet() {
        this.showModal(true)
      },

      showModal(isEdit) {
        const key = Date.now()
        this.$store.commit('game/addOpenModal',
                           {
                             name: 'planet',
                             key,
                             isNew: false,
                             isEdit: isEdit,
                             planet: this.planet,
                           })
      },

      deletePlanet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'remove',
          data: { id: this.planet.id, type: 'menu_item' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  .planet-item-grid {
    display: grid;
    grid-template-columns: 1fr max-content max-content max-content;
    grid-column-gap: 5px;
    justify-items: center;
    align-items: center;
  }
</style>

<template>
  <div>
    <loader v-if="!loaded" />
    <game-form v-if="loaded" :list="list" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import GameForm from '../../components/New/GameForm'
  import Loader from '../../../ui/components/Loader'

  export default {
    name: 'NewGame',
    components: { GameForm, Loader },
    computed: {
      ...mapState({
        systems: (state) => state.systems,
      }),

      loaded: {
        get() {
          return this.systems.loaded
        },
      },

      list: {
        get() {
          return this.systems.list
        },
      },
    },
    created() {
      this.$store.dispatch('loadSystems')
    },
  }
</script>

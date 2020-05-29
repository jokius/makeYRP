<template>
  <v-app id="inspire">
    <v-content>
      <v-container class="fill-height" fluid>
        <v-row
          align="center"
          justify="center"
        >
          <v-col
            cols="12"
            sm="8"
            md="4"
          >
            <loader v-if="!loaded" />
            <new-form v-if="loaded" :list="list" />
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'
  import Loader from '../../components/Loader'
  import NewForm from '../../components/games/NewForm'

  export default {
    components: { NewForm, Loader },

    fetch({ store, $axios }) {
      return store.dispatch('systems/load', $axios)
    },

    computed: {
      ...mapState({
        loaded: state => state.systems.loaded,
        list: state => state.systems.list,
      }),
    },
  }
</script>

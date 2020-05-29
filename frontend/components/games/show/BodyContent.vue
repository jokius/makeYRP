<template>
  <div :key="currentPage.id" :style="style">
    <board />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Board from './Board'
  import { PageModel } from '../../../models/PageModel'

  export default {
    name: 'BodyContent',
    components: { Board },

    computed: {
      ...mapState({
        currentPage: state => state.game.currentPage,
      }),

      background: {
        get() {
          const params = this.currentPage.params || new PageModel().defaultParams
          return params.background
        },
      },

      style: {
        get() {
          return {
            backgroundColor: this.background.color,
          }
        },
      },
    },
  }
</script>

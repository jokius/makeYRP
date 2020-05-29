<template>
  <draggable-dialog
    :on-close="onClose"
    title="Новая страница"
    :width="300"
    :height="200"
    :size="{}"
  >
    <template v-slot:body>
      <v-container class="fill-height page-modal-body" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-form>
              <v-text-field
                v-model="name"
                required
                color="indigo"
                label="Название"
              />
            </v-form>
          </v-col>
        </v-row>
      </v-container>
    </template>
    <template v-slot:actions>
      <v-btn
        dark
        color="indigo"
        @click="onClose"
      >
        Закарыть
      </v-btn>
      <v-spacer />
      <v-btn
        :disabled="!isValid"
        color="indigo"
        @click="save"
      >
        <span :class="{ whiteText: isValid }">Создать</span>
      </v-btn>
    </template>
  </draggable-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  import DraggableDialog from './DraggableDialog'

  export default {
    name: 'PageModal',
    components: { DraggableDialog },
    props: {
      uniqKey: { type: Number, required: true },
    },
    computed: {
      ...mapState({
        pageName: state => state.game.pageName,
      }),

      isValid() {
        return this.name && this.name !== ''
      },

      name: {
        get() {
          return this.pageName
        },
        set(value) {
          this.$store.commit('game/updatePageName', value)
        },
      },
    },
    methods: {
      onClose() {
        this.$store.commit('game/removeOpenModal', this.uniqKey)
        this.name = ''
      },

      save() {
        this.$store.commit('game/removeOpenModal', this.uniqKey)
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: { name: this.name, type: 'page' },
        })
        this.name = ''
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .whiteText {
    color: $white;
  }

  .page-modal-body {
    height: 100px;
  }
</style>

<template>
  <draggable-dialog
    v-model="size"
    :on-close="onClose"
    title="Планета"
    :width="size.width"
    :height="size.height"
    :disable-actions="!isEdit"
    resizable
  >
    <template v-slot:body>
      <edit-planet-body v-if="isEdit" :planet="isNew ? privatePlanet : planet" :is-new="isNew" :size="size" />
      <view-planet-body v-else />
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
        dark
        color="indigo"
        @click="change"
      >
        {{ isNew ? 'Добавить': 'Изменить' }}
      </v-btn>
    </template>
  </draggable-dialog>
</template>

<script>


  import EditPlanetBody from './EditPlanetBody'
  import ViewPlanetBody from './ViewPlanetBody'

  import DraggableDialog from '../../../../../Games/components/Show/DraggableDialog'
  import { REMOVE_OPEN_MODAL } from '../../../../../Games/stores/mutation-types'
  export default {
    name: 'PlanetModal',
    components: { ViewPlanetBody, EditPlanetBody, DraggableDialog },

    props: {
      planet: { type: Object, required: true },
      uniqKey: { type: Number, required: true },
      isEdit: { type: Boolean, required: true },
      isNew: { type: Boolean, required: true },
    },

    data() {
      return {
        privatePlanet: {
          params: {
            name: "",
            ucgs: [],
            planetFeature: {
              name: "",
              description: "",
            },
          },
        },


        privateTitle: 'Новая заметка',
        privateText: '',
        minWidth: '516px',
        privateWidth: 616,
        privateHeight: 450,
        editorOffsetH: 217,
        bodyOffsetH: 177,
      }
    },

    computed: {
      size: {
        get() {
          return { width: this.privateWidth, height: this.privateHeight }
        },

        set({ width, height }) {
          this.privateWidth = width
          this.privateHeight = height
        },
      },

      width: {
        get() {
          const width = this.size.width
          return typeof width === 'number' ? `${width}px` : width
        },
      },

      height: {
        get() {
          const height = this.size.height
          return typeof height === 'number' ? `${height - this.bodyOffsetH}px` : `calc(${height} - 112px)`
        },
      },
    },

    methods: {
      change() {
        if (this.isNew) {
          this.$cable.perform({
            channel: 'GameChannel',
            action: 'add',
            data: { ...this.privatePlanet, menu_id: this.planet.menuId, type: 'menu_item' },
          })
        } else {
          this.$cable.perform({
            channel: 'GameChannel',
            action: 'change',
            data: { ...this.planet, type: 'menu_item' },
          })
        }

        this.onClose()
      },

      onClose() {
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
      },
    },
  }
</script>

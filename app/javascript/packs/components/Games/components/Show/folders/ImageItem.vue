<template>
  <right-click-menu :position="position" :current-obj="item">
    <v-btn
      height="auto"
      width="auto"
      text
      @click="select"
      @contextmenu="handler($event)"
    >
      <span :class="[{select: isSelected}, 'content']">
        <v-badge
          v-model="isSelected"
          color="purple"
          overlap
        >
          <template v-slot:badge>
            <v-icon dark>
              mdi-check
            </v-icon>
          </template>
          <v-img
            :lazy-src="image.versions.lazy"
            :src="image.versions.thumb"
            aspect-ratio="1"
            contain
          >
            <template v-slot:placeholder>
              <v-row
                class="fill-height ma-0"
                align="center"
                justify="center"
              >
                <v-progress-circular indeterminate color="grey lighten-5" />
              </v-row>
            </template>
          </v-img>
        </v-badge>
        <span class="text">{{ image.name }}</span>
      </span>
    </v-btn>
  </right-click-menu>
</template>

<script>
  import RightClickMenu from '../RightClickMenu'
  import { mousePosition } from '../../../../../lib/mousePosition'
  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../../stores/mutation-types'

  export default {
    name: 'ImageItem',
    components: { RightClickMenu },
    model: {
      prop: 'currentSelected',
      event: 'select',
    },

    props: {
      image: { type: Object, required: true },
      currentSelected: { type: Number, default: 0 },
    },

    data: () => ({
      position: {
        x: 0,
        y: 0,
      },
    }),

    computed: {
      versions: {
        get() {
          return this.image.versions
        },
      },

      isSelected: {
        get() {
          return this.image.id === this.currentSelected
        },
      },

      item: {
        get() {
          return {
            type: 'image',
            id: this.image.id,
            name: this.image.name,
          }
        },
      },
    },

    methods: {
      handler(e) {
        this.position = mousePosition(e)
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `image-${this.image.id}`)
        e.preventDefault()
      },

      select() {
        this.$emit('select', this.image.id)
      },
    },
  }
</script>

<style scoped lang="scss">
  .v-btn {
    text-transform: none;
  }

  .content {
    display: flex;
    flex-direction: column;
  }

  .text {
    width: 150px;
    font-size: 0.65rem;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .select {
    border: 2px solid indigo;
  }
</style>

<template>
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
    <v-btn
      height="auto"
      width="auto"
      text
      @click="select"
    >
      <span :class="[{select: isSelected}, 'content']">
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
        <span class="text">{{ image.name }}</span>
      </span>
    </v-btn>
  </v-badge>
</template>

<script>
  export default {
    name: 'ImageItem',

    model: {
      prop: 'currentSelected',
      event: 'select',
    },

    props: {
      image: { type: Object, required: true },
      currentSelected: { type: Number, default: 0 },
    },

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
    },

    methods: {
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

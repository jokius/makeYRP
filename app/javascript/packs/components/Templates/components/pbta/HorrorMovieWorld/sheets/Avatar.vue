<template>
  <div>
    <v-btn
      class="button"
      outlined
      @click="openSelect = true"
    >
      <v-img
        v-if="sheet.imgThumb"
        class="image"
        :src="sheet.imgThumb"
        :lazy-src="sheet.imgLazy"
        :alt="sheet.name"
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
      <v-icon
        v-else
        dark
        size="280"
        :title="sheet.name"
      >
        mdi-account
      </v-icon>
    </v-btn>

    <folders-modal
      v-if="openSelect"
      :target-obj="targetSheet"
      :open-dialog="openSelect"
      @close="openSelect = false"
    />
  </div>
</template>

<script>
  import FoldersModal from '../../../../../Games/components/Show/folders/FoldersModal'

  export default {
    name: 'Avatar',
    components: { FoldersModal },
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        openSelect: false,
      }
    },

    computed: {
      targetSheet: {
        get() {
          return {
            target: 'sheet',
            id: this.sheet.id,
          }
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  .button {
    border: none;
    width: 200px;
    min-height: 260px;
  }

  .image {
    width: 100%;
    max-height: 260px;
  }
</style>

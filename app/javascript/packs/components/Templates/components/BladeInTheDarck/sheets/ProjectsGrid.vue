<template>
  <div class="grid-projects">
    <div v-for="row in lastRow" :key="`row-${row}`" class="inline-flex">
      <div v-for="col in lastCol" :key="`col-${col}`" class="grid-cell">
        <div
          :class="[{'disabled-cell': isDisabledCell(row, col) }, 'info-block']"
          @click="changeEnable(row, col)"
        >
          <div v-if="!isDisabledCell(row, col)" :class="[{ enable: isCellEnable(row, col) }, 'box']" />
          <div v-else />
          <span class="title">{{ cellName(row, col) }}</span>
          <span class="description">{{ cellDescription(row, col) }}</span>
        </div>
        <div v-if="col !== lastCol" :class="`separator ${colConnection(row, col)}`" />
        <div v-if="row !== lastRow" :class="`separator ${rowConnection(row, col)}`" />
      </div>
    </div>
  </div>
</template>

<script>
  import { get } from 'lodash'

  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'ProjectsGrid',
    props: {
      sheet: { type: Object, required: true },
      projects: { type: Array, required: true },
      projectsKey: { type: String, required: true },
    },

    computed: {
      lastRow: {
        get() {
          return this.getMaxAttribute('row')
        },
      },

      lastCol: {
        get() {
          return this.getMaxAttribute('col')
        },
      },
    },

    methods: {
      getMaxAttribute(attribute) {
        if (this.projects.length === 0) return 0

        return Math.max.apply(Math, this.projects.map(project => project[attribute]))
      },

      rowConnection(row, col) {
        const connected = get(this.getCell(row, col), 'in.bottom', false)
        return connected ? 'row-connected' : 'blank'
      },

      colConnection(row, col) {
        const connected = get(this.getCell(row, col), 'in.right', false)
        return connected ? 'col-connected' : 'blank'
      },

      isDisabledCell(row, col) {
        return get(this.getCell(row, col), 'disabled', false)
      },

      changeEnable(row, col) {
        const cell = this.getCell(row, col)
        if (typeof cell.row === 'undefined') return

        const value = !cell.enable
        const index = this.projects.findIndex(project => project.row === cell.row && project.col === cell.col)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `${this.projectsKey}[${index}].enable`,
                             value,
                           })

        this.saveSheet()
      },

      cellName(row, col) {
        return get(this.getCell(row, col), 'name', '')
      },

      isCellEnable(row, col) {
        return get(this.getCell(row, col), 'enable', false)
      },

      cellDescription(row, col) {
        return get(this.getCell(row, col), 'description', '')
      },

      getCell(row, col) {
        return this.projects.find(project => project.row === row && project.col === col) || {}
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .inline-flex {
    display: inline-flex;
  }

  .grid-projects {
    display: grid;
    grid-template-columns: 1fr;
    width: max-content;
  }

  .grid-cell {
    display: grid;
    grid-template-areas:
      'info-block col-connected'
      'row-connected row-connected';
  }

  .info-block {
    grid-area: info-block;
    cursor: pointer;
    width: 160px;
    height: 130px;
    background-color: $white;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 15px max-content max-content;
    grid-row-gap: 10px;
  }

  .separator {
    height: 23px;
    width: 23px;
  }

  .col-connected {
    grid-area: col-connected;
    position: relative;
    top: 50%;
    background-color: $white;
  }

  .row-connected {
    grid-area: row-connected;
    position: relative;
    left: calc(50% - 23px);
    background-color: $white;
  }

  .title {
    line-height: 14px;
    font-size: 14px!important;
    font-weight: bold;
    text-transform: uppercase;
    text-align: center;
    justify-self: center;
    align-self: center;
  }

  .description {
    font-style: italic;
    line-height: 14px;
    font-size: 14px!important;
    text-align: center;
  }

  .box {
    width: 15px;
    height: 15px;
    border: 2px solid $black;
    background-color: $white;
  }

  .enable {
    background-color: $black;
  }

  .disabled-cell {
    cursor: default;
    background-color: $gray24;
    color: $white;
  }
</style>

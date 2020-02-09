<template>
  <right-click-menu :position="position" :current-obj="item" :replaced-items="menuItems">
    <div
      :style="baseStyle"
      class="pointer"
      @contextmenu="handler($event)"
    >
      <span :style="{ ...titleStyle, ...selfTitleStyle }" class="clock-title">
        <i>{{ title }}</i>
        ({{ counter.max }})
      </span>
      <div :style="clockStyle" class="clock" @click="upPart" />
    </div>
  </right-click-menu>
</template>

<script>
  import { mapState } from 'vuex'
  import RightClickMenu from '../../../../Games/components/Show/RightClickMenu'
  import { mousePosition } from '../../../../../lib/mousePosition'
  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Clock',
    components: { RightClickMenu },
    model: {
      prop: 'counter',
      event: 'change',
    },

    props: {
      counter: { type: Object, required: true },
      title: { type: String, required: true },
      selfTitleStyle: { type: Object, default: () => ({}) },
      titlePosition: { type: String, default: 'left' },
      background: { type: String, default: 'white' },
      color: { type: String, default: 'black' },
    },

    data: () => ({
      position: {
        x: 0,
        y: 0,
      },
    }),

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      baseStyle: {
        get() {
          let flexDirection = 'row'
          switch (this.titlePosition) {
            case 'top':
              flexDirection = 'column'
              break
            case 'bottom':
              flexDirection = 'column-reverse'
              break
            case 'right':
              flexDirection = 'row-reverse'
              break
            default:
              break
          }

          return { display: 'flex', flexDirection }
        },
      },

      titleStyle: {
        get() {
          const style = {}
          if (this.titlePosition === 'left' || this.titlePosition === 'right') {
            style.marginTop = '23px'
            style.marginRight = '2px'
          }

          return style
        },
      },

      clockStyle: {
        get() {
          const background = this.background
          const color = this.color
          const proportion = this.counter.current / this.counter.max
          const angle = Math.round(360 * (proportion % 0.5) - 90)
          const grads = [
            `linear-gradient(${angle}deg, ${proportion < 0.5 ? background : color } 50%, transparent 50%)`,
            `linear-gradient(-90deg, ${color} 50%, transparent 50%)`,
          ]

          return {
            backgroundColor: proportion === 1 ? color : background,
            backgroundImage: grads.join(','),
            border: `2px solid ${color}`,
          }
        },
      },

      item: {
        get() {
          return {
            type: 'clock',
            id: this.counter.id || Date.now(),
          }
        },
      },

      menuItems: {
        get() {
          return [{ title: 'Откатить', callback: () => this.downPart() }]
        },
      },
    },

    methods: {
      handler(e) {
        this.position = mousePosition(e)
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `${this.item.type}-${this.item.id}`)
        e.preventDefault()
      },

      upPart() {
        const current = this.counter.current
        const value = current < this.counter.max ? current + 1 : 0
        this.$emit('change', value)
      },

      downPart() {
        const current = this.counter.current
        const value = current === 0 ? this.counter.max : current - 1
        this.$emit('change', value)
      },
    },
  }
</script>

<style scoped lang="scss">
  .clock {
    width: 70px;
    height: 70px;
    display: block;
    border-radius: 50%;
  }

  .pointer {
    cursor: pointer;
  }
</style>

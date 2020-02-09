<template>
  <div>
    <div class="grid-attributes">
      <div
        v-for="(attribute, index) in attributes"
        :key="attribute.key"
        class="attribute"
      >
        <div class="title-grid black">
          <span class="title">{{ attribute.name }}</span>
          <div class="d6" @click="rollModal(attributeLevel(attribute), attribute.name)">
            <span class="text">d6</span>
          </div>
          <div class="exp-list">
            <div
              v-for="number in 6"
              :key="`${attribute.key}Exp-${number}`"
              :class="`button bottom-block ${attributeColorClass(index, number)}`"
              @click="changeExp(`attributes[${index}].current`, attribute.current < number)"
            />
          </div>
        </div>
        <div class="skills">
          <div
            v-for="(skill, skillIndex) in attribute.skills"
            :key="skill.key"
            class="skill"
          >
            <div
              v-for="skillNumber in skill.max"
              :key="`${skill.key}Exp-${skillNumber}`"
              class="skill-exp"
            >
              <div
                :class="`circle ${skillColorClass(index, skillIndex, skillNumber)}`"
                @click="changeExp(`attributes[${index}].skills[${skillIndex}].current`,skill.current < skillNumber)"
              />
              <div v-if="skillNumber === attributeLevel(attribute)" class="right-border" />
            </div>
            <span class="skill-title">{{ skill.name }}</span>
            <div class="d6" @click="rollModal(skill.current, skill.name)">
              <span class="text">d6</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <roll-modifier-modal v-model="obj" :sheet="sheet" />
  </div>
</template>

<script>
  import { get } from 'lodash'

  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import RollModifierModal from '../modals/RollModifierModal'

  export default {
    name: 'Attributes',
    components: { RollModifierModal },
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        dicesProps: {
          name: '',
          dices: 0,
        },

        modalOpen: false,
      }
    },

    computed: {
      attributes: {
        get() {
          return this.sheet.params.attributes
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, modifier: 0 }
        },

        set({ open, modifier, isClose }) {
          if (!isClose) this.roll(parseInt(this.dicesProps.dices) + parseInt(modifier))
          this.modalOpen = open
        },
      },
    },

    methods: {
      attributeColorClass(index, number) {
        return this.attributes[index].current >= number ? 'full-gray' : 'full-white'
      },


      skillColorClass(index, skillIndex, number) {
        return this.attributes[index].skills[skillIndex].current >= number ? 'select' : 'not-select'
      },

      changeExp(path, isIncrement) {
        const value = get(this, path) + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path,
                             value,
                           })

        this.saveSheet()
      },

      attributeLevel(attribute) {
        let level = 0

        for (let i = 0; attribute.skills[0].max >= i; i++) {
          const filterSkills = attribute.skills.filter(item => item.current >= i)
          if (filterSkills.length === attribute.skills.length) level++
        }

        return level
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },

      rollModal(dices, name) {
        this.dicesProps.dices = dices
        this.dicesProps.name = name
        this.modalOpen = true
      },

      roll(quantity) {
        const dices = { d6: quantity }
        this.$store.dispatch('sendMessage', {
          as: this.sheet.id,
          name: this.dicesProps.name,
          dices,
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .black {
    background-color: $black;
    color: $white;
    .d6 {
      border: 1px solid $white;
      background-color: $white;
      color: $black;
      margin-top: 3px;
      margin-left: 10px;
    }
  }

  .title-grid {
    display: grid;
    grid-template-columns: max-content 1fr max-content;
    height: 30px;
    margin-top: 5px;
  }

  .title {
    line-height: 30px;
    margin-left: 5px;
  }

  .exp-list {
    display: inline-flex;
  }

  .skill {
    display: grid;
    grid-template-columns: repeat(4, 25px) 1fr max-content;
    grid-auto-rows: 25px;
    margin-left: 10px;
    margin-top: 5px;
  }

  .skill-title {
    margin-top: -4px;
  }

  .skill-exp {
    position: relative;
  }

  .bottom-block {
    width: 10px;
    height: 40px;
  }

  .right-border {
    position: relative;
    left: 18px;
    bottom: 16px;
    width: 1px;
    height: 30px;
    background-color: $black;
  }

  .button {
    margin-right: 10px;
    cursor: pointer;
  }

  .full-gray {
    background:
      linear-gradient(-45deg, transparent 15px, $gray42 0);
  }

  .full-white {
    background:linear-gradient(-45deg, transparent 15px, $white 0);
  }

  .circle {
    cursor: pointer;
    background-color: #FFFFFF;
    width: 50%;
    height: 50%;
    border-radius: 50%;
    border: 1px solid $black;
  }

  .select {
    background: $black;
  }

  .not-select {
    background: $white;
  }

  .button-roll {
    margin-top: -4px;
  }

  .d6 {
    cursor: pointer;
    width: 25px;
    height: 25px;
    border-radius: 3px;
    border: 1px solid $black;
    background-color: $black;
    color: $white;
    margin-right: 10px;
    .text {
      position: relative;
      top: 1px;
      left: 2px;
    }
  }
</style>

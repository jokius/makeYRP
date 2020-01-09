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
              <span v-if="skillNumber === 1" class="right-border" />
            </div>
            <span class="skill-title">{{ skill.name }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { get } from 'lodash'

  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'Attributes',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      attributes: {
        get() {
          return this.sheet.params.attributes
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

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .black {
    background-color: $black;
    color: $white;
  }

  .title-grid {
    display: grid;
    grid-template-columns: 1fr max-content;
    height: 30px;
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
    grid-template-columns: repeat(4, 25px) max-content;
    grid-auto-rows: 25px;
    margin-left: 10px;
    margin-top: 5px;
  }

  .skill-title {
    margin-top: -10px;
  }

  .skill-exp {
    position: relative;
  }

  .bottom-block {
    width: 10px;
    height: 40px;
  }

  .right-border {
    border-right: 1px solid $black;
    position: relative;
    left: 75%;
    bottom: 18px;
    padding-top: 15px;
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
</style>

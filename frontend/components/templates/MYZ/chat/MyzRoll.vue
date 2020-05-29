<template>
  <div class="grid-message">
    <div class="dice-pool">
      <div
        v-for="(dice, index) in roll.attribute"
        :key="`attribute-${index}`"
        class="attribute dice"
      >
        <span v-if="dice > 1 && dice < 6" class="text">{{ dice }}</span>
        <v-icon v-else-if="dice === 1" class="icon" color="black" size="50">mdi-biohazard</v-icon>
        <v-icon v-else class="icon" color="black" size="50">mdi-radioactive</v-icon>
      </div>
      <div
        v-for="(dice, index) in roll.skill"
        :key="`skill-${index}`"
        class="skill dice"
      >
        <span v-if="dice < 6" class="text">{{ dice }}</span>
        <v-icon v-else class="icon" color="black" size="50">mdi-radioactive</v-icon>
      </div>
      <div
        v-for="(dice, index) in roll.gear"
        :key="`gear-${index}`"
        class="gear dice"
      >
        <span v-if="dice > 1 && dice < 6" class="text">{{ dice }}</span>
        <img v-else-if="dice === 1" src="/images/MYZ/explosion.png" class="image" alt="кубик снаряжения" />
        <v-icon v-else class="icon" color="white" size="50">mdi-radioactive</v-icon>
      </div>
      <div
        v-for="(dice, index) in roll.d6"
        :key="`d6-${index}`"
        class="d6 dice"
      >
        <span class="text">{{ dice }}</span>
      </div>
    </div>
    <p>Успехи: {{ success }}</p>
    <p>Провалы характеристики: {{ attributeFails }}</p>
    <p>Провалы снаряжения: {{ gearFails }}</p>
    <p>Остальные: {{ other }}</p>
    <v-btn v-if="other > 0" color="orange" @click="pushing">
      Рискнуть!
    </v-btn>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'MyzRoll',

    props: {
      roll: { type: Object, required: true },
      as: { type: Number, required: true },
      prevSuccess: { type: Number, required: true },
      prevAttributeFails: { type: Number, required: true },
      prevGearFails: { type: Number, required: true },
    },

    computed: {
      ...mapState({
        system: state => state.game.info.system,
      }),

      success: {
        get() {
          let success = this.prevSuccess
          this.roll.attribute.forEach(item => success += (item === 6 ? 1 : 0))
          this.roll.skill.forEach(item => success += (item === 6 ? 1 : 0))
          this.roll.gear.forEach(item => success += (item === 6 ? 1 : 0))
          return success
        },
      },

      attributeFails: {
        get() {
          let fails = this.prevAttributeFails
          this.roll.attribute.forEach(item => fails += (item === 1 ? 1 : 0))
          return fails
        },
      },

      gearFails: {
        get() {
          let fails = this.prevGearFails
          this.roll.gear.forEach(item => fails += (item === 1 ? 1 : 0))
          return fails
        },
      },

      otherAttributes: {
        get() {
          let other = 0
          this.roll.attribute.forEach(item => other += (item !== 1 && item !== 6 ? 1 : 0))
          return other
        },
      },

      otherSkills: {
        get() {
          let other = 0
          this.roll.skill.forEach(item => other += (item !== 6 ? 1 : 0))
          return other
        },
      },

      otherGear: {
        get() {
          let other = 0
          this.roll.gear.forEach(item => other += (item !== 1 && item !== 6 ? 1 : 0))

          return other
        },
      },

      other: {
        get() {
          return this.otherAttributes + this.otherSkills + this.otherGear
        },
      },
    },

    methods: {
      pushing() {
        const dices = {
          attribute: this.otherAttributes,
          skill: this.otherSkills,
          gear: this.otherGear,
        }

        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.as,
              dices,
              prevSuccess: this.success,
              prevAttributeFails: this.attributeFails,
              prevGearFails: this.gearFails,
            },
          },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  $border: 3px solid $black;
  $size: 60px;

  .grid-message {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
  }

  .dice-pool {
    display: flex;
    flex-flow: wrap;
  }

  .dice {
    margin: 1px;
    width: $size;
    height: $size;
  }

  .text {
    font-size: 50px;
    position: relative;
    bottom: 10px;
    left: 8px;
  }

  .icon {
    position: relative;
    left: 4%;
  }

  .image {
    width: 50px;
    height: 50px;
    margin-top: 2px;
    margin-left: 2px;
  }

  .attribute {
    background-color: yellow;
    border-radius: 8px;
    border: $border;
    color: $black;
  }

  .skill {
    background-color: green;
    border-radius: 8px;
    border: $border;
    color: $white;
  }

  .gear {
    border-radius: 8px;
    border: $border;
    background-color: $black;
    color: $white;
  }

  .d6 {
    border-radius: 8px;
    border: $border;
    background-color: $white;
    color: $black;
  }
</style>

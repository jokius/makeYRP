<template>
  <auto-full v-if="body.autoFull" :body="body" />
  <auto-part v-else-if="body.autoPart" :body="body" />
  <damage-roll v-else-if="body.damage" :body="body" />
  <dice-roll v-else :body="body" />
</template>

<script>
  import AutoFull from './AutoFull'
  import AutoPart from './AutoPart'
  import DiceRoll from './DiceRoll'
  import DamageRoll from './DamageRoll'

  export default {
    name: 'EouRoll',
    components: { DamageRoll, DiceRoll, AutoPart, AutoFull },
    props: {
      body: { type: Object, required: true },
    },
  }
</script>

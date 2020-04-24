<template>
  <auto-full v-if="body.autoFull" :body="body" />
  <auto-part v-else-if="body.autoPart" :body="body" />
  <dice-roll v-else :body="body" />
</template>

<script>
  import AutoFull from './AutoFull'
  import AutoPart from './AutoPart'
  import DiceRoll from './DiceRoll'

  export default {
    name: 'EouRoll',
    components: { DiceRoll, AutoPart, AutoFull },
    props: {
      body: { type: Object, required: true },
    },
  }
</script>

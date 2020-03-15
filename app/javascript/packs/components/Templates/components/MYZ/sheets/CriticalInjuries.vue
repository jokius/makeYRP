<template>
  <div class="grid">
    <div
      v-for="(item, index) in criticalInjuries"
      :key="`criticalInjuries-${index}`"
      class="grid-body"
    >
      <span>{{ item.name }}</span>
      <span>Смертельно: {{ lethal(item) }}</span>
      <span>Эффект: {{ item.effect }}</span>
      <span>{{ item.timeLimit }}</span>
      <span>{{ item.healingTime }}</span>
      <v-btn @click="remove(index)">
        Убрать травму
      </v-btn>
    </div>
    <v-btn @click="addCriticalInjury">
      Добавить травму
    </v-btn>
    <v-btn @click="addNonTypicalDamage">
      Добавить сит. урон
    </v-btn>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { Myz } from '../../../../../lib/Myz'

  export default {
    name: 'CriticalInjuries',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      criticalInjuries: {
        get() {
          return this.sheet.params.critical_injuries
        },
      },
    },

    methods: {
      lethal(item) {
        let lethal = item.lethal ? 'Да' : 'Нет'
        if (item.penalty) lethal += `, ${item.penalty}`;
        return lethal
      },

      remove(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'critical_injuries',
                             value: index,
                             remove: true,
                           })

        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },

      addCriticalInjury() {
        const criticalInjury = Myz.criticalInjury(this.tables.critical_injuries)
        if (!criticalInjury) return

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `critical_injuries.${this.criticalInjuries.length}`,
                             value: criticalInjury,
                           })

        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },

      addNonTypicalDamage() {
        const criticalInjury = Myz.nonTypicalDamage()
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `critical_injuries.${this.criticalInjuries.length}`,
                             value: criticalInjury,
                           })

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

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: max-content;
    grid-row-gap: 5px;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
    border: 1px solid $black;
    padding-left: 5px;
    padding-bottom: 3px;
  }
</style>

<template>
  <v-dialog :value="obj.open" max-width="600" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Выбрать предметы
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <div v-for="(select, index) in selects" :key="`starting-equipment-${index}`" class="selects">
              <v-select
                :value="selectItem(list[index])"
                :items="selectItems(select.items)"
                color="indigo"
                :label="select.title"
                :multiple="select.multiple"
                @change="(values) => list[index] = values"
              />
            </div>
          </v-col>
        </v-row>
      </v-container>

      <v-divider />

      <v-card-actions>
        <v-btn
          dark
          color="indigo"
          @click="close"
        >
          Закарыть
        </v-btn>
        <v-spacer />
        <v-btn
          dark
          color="indigo"
          @click="add"
        >
          Добавить
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'AddStartingEquipmentModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
      role: { type: String, required: true },
    },

    data() {
      return {
        list: [],
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      selects: {
        get() {
          return this.tables.selectEquipment[this.role]
        },
      },
    },

    methods: {
      selectItem(values = null) {
        if (!values) return null

        if (Array.isArray(values)) {
          return values.map(item => ({ text: item.name, value: item }))
        } else {
          return { text: values.name, value: values }
        }
      },

      selectItems(items) {
        return items.map(item => ({ text: item.name, value: item }))
      },

      add() {
        const items = this.list.flat()
        this.$emit('completed', { open: false, items })
        this.list = []
      },

      close() {
        this.$emit('completed', { open: false, items: [] })
        this.list = []
      },
    },
  }
</script>

<template>
  <div class="grid-message">
    <div class="grid-info">
      <v-avatar tile color="indigo" size="50" class="avatar">
        <v-img
          v-if="avatar"
          :src="avatar"
          :alt="nickname"
        />
        <v-icon
          v-else
          size="50"
          dark
          :title="nickname"
        >
          mdi-account-circle
        </v-icon>
      </v-avatar>

      <b class="nickname">{{ nickname }}</b>
      <v-tooltip top class="time">
        <template v-slot:activator="{ on }">
          <i v-on="on">{{ time }}</i>
        </template>
        <span>{{ fullDate }}</span>
      </v-tooltip>
    </div>

    <div class="grid-body">
      <span v-if="body.text" class="chat-text">{{ body.text }}</span>
      <myz-roll
        v-if="!body.noSystem && body.dices && system === 'mutant_year_zero'"
        :as="character.id || -1"
        :roll="body.dices"
        :prev-success="body.prevSuccess || 0"
        :prev-attribute-fails="body.prevAttributeFails || 0"
        :prev-gear-fails="body.prevGearFails || 0"
      />
      <bid-roll
        v-else-if="!body.noSystem && body.dices && system === 'blade_in_the_dark'"
        :name="body.name || ''"
        :roll="body.dices"
      />
      <hmw-roll
        v-else-if="!body.noSystem && body.dices && system === 'horror_movie_world'"
        :body="body"
      />
      <eou-roll
        v-else-if="(!body.noSystem && body.dices || body.autoFull || body.autoPart) && system === 'edge_of_universe'"
        :body="body"
      />
      <default-roll v-else-if="body.dices" :roll="body.dices" />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import DefaultRoll from './DefaultRoll'

  import MyzRoll from '../../../templates/MYZ/chat/MyzRoll'
  import BidRoll from '../../../templates/BladeInTheDarck/chat/BidRoll'
  import HmwRoll from '../../../templates/pbta/HorrorMovieWorld/chat/HmwRoll'
  import EouRoll from '../../../templates/pbta/EdgeOfUniverse/chat/EouRoll'
  import * as dateTime from '../../../../lib/dateTime'

  export default {
    name: 'ChatMessage',
    components: { EouRoll, HmwRoll, BidRoll, DefaultRoll, MyzRoll },

    props: {
      message: { type: Object, required: true },
    },

    computed: {
      ...mapState({
        system: state => state.game.info.system,
        sheets: state => state.game.sheets,
      }),

      user: {
        get() {
          return this.message.user
        },
      },

      character: {
        get() {
          let character = {}
          if (this.body.as) {
            character = this.sheets.find(sheet => sheet.id === this.body.as) || {}
          }

          return character
        },
      },

      nickname: {
        get() {
          return this.character.name || this.user.nickname
        },
      },

      avatar: {
        get() {
          return this.character.imgChat || this.user.imgChat
        },
      },

      body: {
        get() {
          return this.message.body
        },
      },

      time: {
        get() {
          return dateTime.toLocaleTime(this.message.createdAt)
        },
      },

      fullDate: {
        get() {
          return `${dateTime.toLocaleDate(this.message.createdAt)} ${dateTime.toLocaleTime(this.message.createdAt)}`
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .grid-message {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    margin-bottom: 5px;
    background-color: $white;
  }

  .grid-info {
    display: grid;
    grid-template-columns: max-content auto max-content;
    grid-column-gap: 5px;
    padding-right: 10px;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
    grid-column-gap: 1px;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    padding-left: 3px;
    padding-right: 10px;
  }

  .chat-text {
    overflow-wrap: anywhere;
  }
</style>

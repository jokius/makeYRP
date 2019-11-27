<template>
  <div class="grid-message">
    <div class="grid-info">
      <v-avatar tile color="indigo" size="50" class="avatar">
        <img
          v-if="user.avatar.chat"
          :src="user.avatar.chat"
          :alt="user.name"
        />
        <v-icon
          v-else
          size="50"
          dark
          :title="user.nikname"
        >
          mdi-account-circle
        </v-icon>
      </v-avatar>

      <b class="nickname">{{ user.nickname }}</b>
      <v-tooltip top class="time">
        <template v-slot:activator="{ on }">
          <i v-on="on">{{ time }}</i>
        </template>
        <span>{{ fullDate }}</span>
      </v-tooltip>
    </div>

    <div class="grid-body">
      <span v-if="body.text">{{ body.text }}</span>
    </div>
  </div>
</template>

<script>
  import * as dateTime from '../../../../../lib/dateTime'

  export default {
    name: 'ChatMessage',

    props: {
      message: { type: Object, required: true },
    },

    computed: {
      user: {
        get() {
          return this.message.user
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
  @import 'app/javascript/packs/components/ui/css/colors';

  .grid-message {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    margin: 5px;
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
</style>

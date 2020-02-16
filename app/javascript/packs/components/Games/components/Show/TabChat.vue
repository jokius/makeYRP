<template>
  <div :class="`base-chat ${isEmptyChat() ? 'empty-chat' : 'chat'}`">
    <div ref="messages" class="messages">
      <chat-message v-for="item in messages" :key="item.id" :message="item" />
    </div>

    <v-text-field
      v-model="text"
      required
      outlined
      placeholder="сообщение..."
      class="field-text"
      @keypress.enter="sendMessage"
    />

    <v-btn
      :dark="text !== ''"
      color="indigo"
      class="bottom-send"
      :disabled="text === ''"
      @click="sendMessage"
    >
      Отправить
    </v-btn>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import ChatMessage from './chat/ChatMessage'

  export default {
    name: 'TabChat',
    components: { ChatMessage },

    data() {
      return {
        text: '',
      }
    },

    computed: {
      ...mapState({
        messages: state => state.game.messages,
      }),
    },

    activated() {
      this.$nextTick(function () {
        this.scrollDown()
      })
    },

    mounted() {
      this.$nextTick(function () {
        this.scrollDown()
      })
    },

    updated() {
      this.$nextTick(function () {
        this.scrollDown()
      })
    },

    methods: {
      isEmptyChat() {
        return this.messages.length === 0
      },

      scrollDown() {
        const messages = this.$refs.messages
        messages.scrollTop = messages.scrollHeight
      },

      sendMessage() {
        if (this.text === '') return

        this.$store.dispatch('sendMessage', { text: this.text })
        this.text = ''
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';
  .base-chat {
    position: relative;
    bottom: 0;
    background-color: #c5c5c5;
  }

  .empty-chat {
    height: calc(100% - 35px * 2);
  }

  .chat {
    top: 70px;
    height: calc(100% - 70px * 2);
  }

  .messages {
    position:absolute;
    height: 100%;
    overflow: auto;
    bottom: 70px;
    width: 100%;
  }

  .field-text {
    position: absolute;
    bottom: 0;
    background-color: $white;
    padding: 5px 5px 0 5px;
    height: 70px;
    width: 100%;
  }

  .bottom-send {
    position: absolute;
    top: 100%;
    left: auto;
    right: 10px;
  }
</style>

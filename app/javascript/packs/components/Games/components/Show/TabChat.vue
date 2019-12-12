<template>
  <div class="chat">
    <div v-chat-scroll="{ always: false, smooth: true, scrollonremoved: true }" class="messages">
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
        messages: (state) => state.game.messages,
      }),
    },

    methods: {
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

  .chat {
    position: relative;
    height: calc(100% - 56px);
    top:0;
    bottom:0;
    background-color: $grayC5;
  }

  .messages {
    position:absolute;
    height: 90%;
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

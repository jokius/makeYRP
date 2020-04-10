<template>
  <v-dialog :value="openDialog" width="300">
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Доступы
      </v-card-title>
      <v-container class="fill-height" fluid>
        <div v-if="!loaded" class="loaded">
          <loader />
        </div>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-form>
              <v-list>
                <div class="user-grid">
                  <span>Игрок</span>
                  <span>Просмотр</span>
                  <span>Изменение</span>
                </div>
                <template v-for="acl in acls">
                  <v-list-item :key="acl.user.id" class="border-bottom">
                    <v-list-item-content>
                      <div v-if="acl.isOwner" class="owner-grid">
                        <span>{{ acl.user.nickname }}</span>
                        <span>Владелец</span>
                      </div>
                      <div v-else class="user-grid">
                        <span>{{ acl.user.nickname }}</span>
                        <span>{{ acl.camRead }}</span>
                        <span>{{ acl.camWrite }}</span>
                      </div>
                    </v-list-item-content>
                  </v-list-item>
                </template>
              </v-list>
            </v-form>
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
          :disabled="!isValid"
          color="indigo"
          @click="rename"
        >
          <span :class="{ whiteText: isValid }">Переименовать</span>
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  import Loader from '../../../ui/components/Loader'
  import { AclUsers } from '../../api'
  import { AclModel } from '../../../../models/AclModel'

  export default {
    name: 'AccessModal',
    components: { Loader },
    model: {
      prop: 'openDialog',
      event: 'open',
    },

    props: {
      openDialog: { type: Boolean, default: false },
      obj: { type: Object, required: true },
    },

    data() {
      return {
        newObjName: this.obj.name,
        acls: [],
        loaded: false,
      }
    },

    computed: {
      isValid() {
        return this.name && this.name !== ''
      },

      name: {
        get() {
          return this.newObjName
        },
        set(value) {
          this.newObjName = value
        },
      },
    },

    created() {
      AclUsers({ ...this.obj }).then(acls => {
        this.acls = acls.map(raw => new AclModel().setInfo(raw))
        this.loaded = true
      })
    },

    methods: {
      close() {
        this.$emit('open', false)
      },

      rename() {
        this.close()
        this.$store.dispatch('renameObj', { ...this.obj, name: this.name })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .whiteText {
    color: $white;
  }
</style>


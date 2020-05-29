import Vue from 'vue'
import panZoom from 'vue-panzoom'

if (process.client) Vue.use(panZoom)

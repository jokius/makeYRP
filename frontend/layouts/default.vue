<template>
  <div>
      <nuxt/>
  </div>
</template>

<style lang="scss">
  @font-face {
    font-family: 'Xolonium';
    src: url('~assets/fonts/Xolonium.ttf') format('truetype');
  }

  @font-face {
    font-family: "Xolonium";
    src: url('~assets/fonts/XoloniumBold.ttf') format('truetype');
    font-weight: bold;
  }

  *::-webkit-scrollbar {
    width: 10px;
  }

  *::-webkit-scrollbar-track {
    box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
  }

  *::-webkit-scrollbar-thumb {
    background-color: darkgrey;
    outline: 1px solid slategrey;
  }

  * {
    font-family: 'Xolonium', serif;
    font-size: 14px;
    :focus {
      outline: none;
    }
  }

  html {
    font-family: "Xolonium", serif;
    font-size: 14px;
    word-spacing: 1px;
    -ms-text-size-adjust: 100%;
    -webkit-text-size-adjust: 100%;
    -moz-osx-font-smoothing: grayscale;
    -webkit-font-smoothing: antialiased;
    box-sizing: border-box;
    overflow-y: auto !important;
    :focus {
      outline: none;
    }
  }
</style>

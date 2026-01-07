<script setup lang="ts">
import Fruit3D from './components/Fruits.vue'
import ParticleBackground from './components/ParticleBackground.vue'
</script>

<template>
  <div id="app">
    <ParticleBackground />
    <main class="app-main">
      <Fruit3D />
    </main>
    <footer class="app-footer">© 2026 All Rights Reserved· 咸少®</footer>
  </div>
</template>

<style scoped>
.app-main {
  padding-bottom: 56px; /* leave space for footer */
  position: relative;
  z-index: 1;
}
.app-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #2c5530, #4a7c59, #6a9c78);
  color: #eee;
  font-size: 14px;
  border-top: 1px solid #eee;
  z-index: 2;
}
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>

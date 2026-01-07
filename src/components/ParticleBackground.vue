<template>
  <canvas ref="canvas" class="particle-canvas"></canvas>
</template>

<script setup lang="ts">
import { onMounted, onBeforeUnmount, ref } from 'vue'

const canvas = ref<HTMLCanvasElement | null>(null)

type Particle = {
  x: number
  y: number
  vx: number
  vy: number
  r: number
}

let ctx: CanvasRenderingContext2D | null = null
let particles: Particle[] = []
let rafId = 0

function resizeCanvas(el: HTMLCanvasElement) {
  const dpr = window.devicePixelRatio || 1
  el.width = Math.floor(el.clientWidth * dpr)
  el.height = Math.floor(el.clientHeight * dpr)
  if (ctx) ctx.setTransform(dpr, 0, 0, dpr, 0, 0)
}

function initParticles(width: number, height: number) {
  particles = []
  const count = Math.min(120, Math.floor((width * height) / 8000))
  for (let i = 0; i < count; i++) {
    particles.push({
      x: Math.random() * width,
      y: Math.random() * height,
      vx: (Math.random() - 0.5) * 0.6,
      vy: (Math.random() - 0.5) * 0.6,
      r: 0.8 + Math.random() * 2.2,
    })
  }
}

function step(el: HTMLCanvasElement) {
  if (!ctx) return
  const w = el.clientWidth
  const h = el.clientHeight
  ctx.clearRect(0, 0, w, h)

  // draw particles
  for (const p of particles) {
    p.x += p.vx
    p.y += p.vy
    if (p.x < -10) p.x = w + 10
    if (p.x > w + 10) p.x = -10
    if (p.y < -10) p.y = h + 10
    if (p.y > h + 10) p.y = -10

    ctx.beginPath()
    ctx.fillStyle = 'rgba(255,255,255,0.85)'
    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
    ctx.fill()
  }

  // draw lines
  const maxDist = 120
  ctx.strokeStyle = 'rgba(255,255,255,0.08)'
  ctx.lineWidth = 1
  for (let i = 0; i < particles.length; i++) {
    const a = particles[i]!
    for (let j = i + 1; j < particles.length; j++) {
      const b = particles[j]!
      const dx = a.x - b.x
      const dy = a.y - b.y
      const d2 = dx * dx + dy * dy
      if (d2 < maxDist * maxDist) {
        const alpha = 1 - Math.sqrt(d2) / maxDist
        ctx.beginPath()
        ctx.strokeStyle = `rgba(255,255,255,${(alpha * 0.12).toFixed(3)})`
        ctx.moveTo(a.x, a.y)
        ctx.lineTo(b.x, b.y)
        ctx.stroke()
      }
    }
  }

  rafId = requestAnimationFrame(() => step(el))
}

onMounted(() => {
  const el = canvas.value!
  ctx = el.getContext('2d')
  if (!ctx) return

  const resize = () => {
    resizeCanvas(el)
    initParticles(el.clientWidth, el.clientHeight)
  }

  resize()
  window.addEventListener('resize', resize)
  rafId = requestAnimationFrame(() => step(el))

  onBeforeUnmount(() => {
    window.removeEventListener('resize', resize)
    cancelAnimationFrame(rafId)
  })
})
</script>

<style scoped>
.particle-canvas {
  position: fixed;
  inset: 0;
  width: 100%;
  height: 100%;
  z-index: 9999;
  pointer-events: none;
  background: transparent;
}
</style>

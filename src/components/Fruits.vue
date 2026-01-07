<template>
  <div class="container">
    <h1 class="title"> Protect healthy fruits </h1>
    <div class="controls">
      <button @click="rotateX += 10" class="control-btn">Rotate X +10°</button>
      <button @click="rotateY += 10" class="control-btn">Rotate Y +10°</button>
      <button @click="rotateZ += 10" class="control-btn">Rotate Z +10°</button>
      <button @click="resetRotation" class="control-btn">Reset</button>
    </div>
    <div class="scene">
      <div 
        class="cube" 
        :style="{
          transform: `rotateX(${rotateX}deg) rotateY(${rotateY}deg) rotateZ(${rotateZ}deg)`
        }"
      >
        <div class="face front">
          <div class="fruit apple"></div>
        </div>
        <div class="face back">
          <div class="fruit orange"></div>
        </div>
        <div class="face right">
          <div class="fruit banana"></div>
        </div>
        <div class="face left">
          <div class="fruit grape"></div>
        </div>
        <div class="face top">
          <div class="fruit strawberry"></div>
        </div>
        <div class="face bottom">
          <div class="fruit watermelon"></div>
        </div>
      </div>
    </div>
    <div class="info">
      <p>Drag to Rotate: Click and drag the fruit cube to rotate in 3D</p>
      <p>Use control buttons to adjust rotation angles</p>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';

export default {
  name: 'Fruit3D',
  setup() {
    const rotateX = ref(45);
    const rotateY = ref(45);
    const rotateZ = ref(45);
    
    // Mouse drag controls
    let isDragging = false;
    let startX = 0;
    let startY = 0;
    let startRotateX = 0;
    let startRotateY = 0;
    
    const handleMouseDown = (e) => {
      isDragging = true;
      startX = e.clientX;
      startY = e.clientY;
      startRotateX = rotateX.value;
      startRotateY = rotateY.value;
      document.body.style.userSelect = 'none';
    };
    
    const handleMouseMove = (e) => {
      if (!isDragging) return;
      
      const deltaX = e.clientX - startX;
      const deltaY = e.clientY - startY;
      
      rotateY.value = startRotateY + deltaX * 0.5;
      rotateX.value = startRotateX - deltaY * 0.5;
    };
    
    const handleMouseUp = () => {
      isDragging = false;
      document.body.style.userSelect = '';
    };
    
    onMounted(() => {
      const cube = document.querySelector('.cube');
      cube.addEventListener('mousedown', handleMouseDown);
      document.addEventListener('mousemove', handleMouseMove);
      document.addEventListener('mouseup', handleMouseUp);
    });
    
    const resetRotation = () => {
      rotateX.value = 45;
      rotateY.value = 45;
      rotateZ.value = 45;
    };
    
    return {
      rotateX,
      rotateY,
      rotateZ,
      resetRotation
    };
  }
};
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  background: linear-gradient(135deg, #2c5530, #4a7c59, #6a9c78);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  font-family: 'Arial', sans-serif;
  overflow: hidden;
}

.container {
  text-align: center;
  padding: 20px;
  color: white;
}

.title {
  font-size: 2.5rem;
  margin-bottom: 20px;
  text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
}

.controls {
  margin-bottom: 30px;
}

.control-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.3);
  color: white;
  padding: 10px 15px;
  margin: 5px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
}

.control-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}

.scene {
  width: 200px;
  height: 200px;
  margin: 40px auto;
  perspective: 1200px;
}

.cube {
  position: relative;
  width: 200px;
  height: 200px;
  transform-style: preserve-3d;
  transition: transform 0.5s ease;
}

.face {
  position: absolute;
  width: 200px;
  height: 200px;
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid rgba(255, 255, 255, 0.3);
  display: flex;
  justify-content: center;
  align-items: center;
  backdrop-filter: blur(5px);
  border-radius: 10px;
}

.front  { transform: translateZ(100px); }
.back   { transform: rotateY(180deg) translateZ(100px); }
.right  { transform: rotateY(90deg) translateZ(100px); }
.left   { transform: rotateY(-90deg) translateZ(100px); }
.top    { transform: rotateX(90deg) translateZ(100px); }
.bottom { transform: rotateX(-90deg) translateZ(100px); }

.fruit {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  position: relative;
  box-shadow: 
    inset -10px -10px 20px rgba(0, 0, 0, 0.3),
    inset 10px 10px 20px rgba(255, 255, 255, 0.2),
    0 10px 20px rgba(0, 0, 0, 0.3);
}

.apple {
  background: radial-gradient(circle at 30% 30%, #ff6b6b, #c0392b);
  border: 2px solid #e74c3c;
}

.apple::before {
  content: '';
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 10px;
  height: 20px;
  background: #8B4513;
  border-radius: 5px 5px 0 0;
}

.apple::after {
  content: '';
  position: absolute;
  top: 25px;
  left: 45%;
  width: 15px;
  height: 8px;
  background: #2ecc71;
  border-radius: 50%;
}

.orange {
  background: radial-gradient(circle at 30% 30%, #ff9f43, #ff6348);
  border: 2px solid #ff7675;
}

.orange::before {
  content: '';
  position: absolute;
  top: 15px;
  left: 20px;
  width: 15px;
  height: 15px;
  background: #8B4513;
  border-radius: 50%;
}

.banana {
  background: radial-gradient(circle at 40% 40%, #ffd700, #f1c40f);
  border: 2px solid #f39c12;
  border-radius: 50% 30% 50% 30%;
  transform: rotate(20deg);
}

.banana::before {
  content: '';
  position: absolute;
  top: 15px;
  left: 20px;
  width: 10px;
  height: 15px;
  background: #8B4513;
  border-radius: 50%;
}

.grape {
  background: radial-gradient(circle at 30% 30%, #8e44ad, #6c3483);
  border: 2px solid #9b59b6;
}

.grape::before {
  content: '';
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 10px;
  height: 20px;
  background: #2c3e50;
  border-radius: 5px 5px 0 0;
}

.strawberry {
  background: radial-gradient(circle at 40% 30%, #e74c3c, #c0392b);
  border: 2px solid #e74c3c;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}

.strawberry::before {
  content: '';
  position: absolute;
  top: 10px;
  left: 50%;
  transform: translateX(-50%);
  width: 15px;
  height: 20px;
  background: #27ae60;
  border-radius: 50%;
}

.watermelon {
  background: radial-gradient(circle at 30% 30%, #2ecc71, #27ae60);
  border: 2px solid #27ae60;
}

.watermelon::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 60px;
  height: 80px;
  background: radial-gradient(circle at 30% 30%, #e74c3c, #c0392b);
  border-radius: 50%;
}

.info {
  margin-top: 30px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
}

.info p {
  margin: 5px 0;
}
</style>
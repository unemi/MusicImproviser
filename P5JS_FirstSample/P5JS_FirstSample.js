function setup() {
  createCanvas(640,480,WEBGL)
}
let x = 0, y = 0, r = 0
function draw() {
  background(220)
  fill(r,255-r,0)
  noStroke()
  rotateX(-PI/6)
  push()
  rotateY(x*PI/180)
  box(50,60,20)
  pop(); push()
  rotateY(-x*PI/180)
  translate(100,0,0)
  sphere(30)
  pop(); push()
  fill(0,0,255)
  rotateY(y*PI/180)
  translate(150,0,0)
  scale(1,2,1)
  sphere(20)
  pop()
  if ((x += 2) > 360) { x = 0 }
  if ((y += 1.5) > 360) { y = 0 }
  if ((r += 4) > 255) { r = 0 }
}

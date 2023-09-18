import './style.css'
import InitWasm from './life-game/life-game.wat?init'

document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
  <canvas id="game"/>
`

const GRID_COLOR = "#CCCCCC";
const DEAD_COLOR = "#FFFFFF";
const ALIVE_COLOR = "#000000";

const colors = {
  0: GRID_COLOR,
  1: DEAD_COLOR,
  2: ALIVE_COLOR,
}

const importOption = {
  canvas: {
    begin_path: (ctx: CanvasRenderingContext2D) => ctx.beginPath(),
    move_to: (ctx: CanvasRenderingContext2D, x: number, y: number) => ctx.moveTo(x, y),
    line_to: (ctx: CanvasRenderingContext2D, x: number, y: number) => ctx.lineTo(x, y),
    set_stroke_style: (ctx: CanvasRenderingContext2D, color: 0 | 1 | 2) => ctx.strokeStyle = colors[color],
    set_fill_style: (ctx: CanvasRenderingContext2D, color: 0 | 1 | 2) => ctx.fillStyle = colors[color],
    stroke: (ctx: CanvasRenderingContext2D) => ctx.stroke(),
    fill_rect: (ctx: CanvasRenderingContext2D, x: number, y: number, width: number, height: number) => ctx.fillRect(x, y, width, height)
  }
}

const wasmModule = await InitWasm(importOption)

class Universe { }

interface LifeGameModule {
  'new': () => Universe,
  'Universe::get_width': (universe: Universe) => number,
  'Universe::get_height': (universe: Universe) => number,
  'Universe::render': (universe: Universe, ctx: CanvasRenderingContext2D, size: number) => void,
}

const {
  'new': universe_new,
  'Universe::get_width': get_width,
  'Universe::get_height': get_height,
  'Universe::render': render,
} = wasmModule.exports as unknown as LifeGameModule

const universe = universe_new()

const width = get_width(universe);
const height = get_height(universe);
const CELL_SIZE = 5;

const canvas = document.querySelector<HTMLCanvasElement>('#game')!
canvas.height = (CELL_SIZE + 1) * height + 1;
canvas.width = (CELL_SIZE + 1) * width + 1;

const ctx = canvas.getContext("2d")!;

const renderLoop = () => {
  render(universe, ctx, CELL_SIZE)

  requestAnimationFrame(renderLoop);
};
requestAnimationFrame(renderLoop);

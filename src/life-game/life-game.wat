(module
 (data (offset (i32.const 10000))
  "\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\F3\02\00\00true\00\00\00\03\00\00\00\00\F3\02\00\00false\00\00\02\00\00\00\00")
 (func $canvas.fill_rect (import "canvas" "fill_rect") (param externref)
  (param i32) (param i32) (param i32) (param i32))
 (func $canvas.move_to (import "canvas" "move_to") (param externref)
  (param i32) (param i32))
 (func $canvas.line_to (import "canvas" "line_to") (param externref)
  (param i32) (param i32))
 (func $canvas.set_stroke_style (import "canvas" "set_stroke_style")
  (param externref) (param i32))
 (func $canvas.set_fill_style (import "canvas" "set_fill_style")
  (param externref) (param i32))
 (func $canvas.stroke (import "canvas" "stroke") (param externref))
 (func $canvas.begin_path (import "canvas" "begin_path") (param externref))
 (global $rael.heap_pointer (mut i32) (i32.const 20000))
 (memory $rael.memory (export "memory") 1)
 (func $rael.gc.malloc (param $size i32) (result i32) (local $old i32)
  (local.set $size (i32.add (local.get $size) (i32.const 4)))
  (local.set $old (global.get $rael.heap_pointer))
  (if
   (i32.gt_s (i32.add (global.get $rael.heap_pointer) (local.get $size))
    (i32.mul (memory.size) (i32.const 65536)))
   (then
    (i32.div_s
     (i32.add
      (i32.sub (i32.add (global.get $rael.heap_pointer) (local.get $size))
       (i32.mul (memory.size) (i32.const 65536)))
      (i32.const 65536))
     (i32.const 65536))
    (memory.grow) (drop)))
  (global.set $rael.heap_pointer
   (i32.add (local.get $old) (local.get $size)))
  (local.get $old))
 (func $rael.get_tag (param $p i32) (result i32)
  (i32.and (i32.load offset=0 (local.get $p)) (i32.const 0xFF)))
 (func $rael.set_tag (param $p i32) (param $tag i32)
  (i32.store offset=0 (local.get $p)
   (i32.or
    (i32.and (i32.load offset=0 (local.get $p)) (i32.const 0xFFFFFF00))
    (local.get $tag))))
 (func $rael.get_len (param $p i32) (result i32)
  (i32.shr_u (i32.load offset=0 (local.get $p)) (i32.const 8)))
 (func $rael.set_len (param $p i32) (param $len i32)
  (i32.store offset=0 (local.get $p)
   (i32.or
    (i32.and (i32.load offset=0 (local.get $p)) (i32.const 0x000000FF))
    (i32.shl (local.get $len) (i32.const 8)))))
 (func $rael.check_range (param $index i32) (param $lo i32) (param $hi i32)
  (if (i32.le_s (local.get $index) (local.get $hi))
   (then
    (if (i32.ge_s (local.get $index) (local.get $lo)) (then)
     (else (unreachable))))
   (else (unreachable))))
 (func $rael.array_length (param $arr i32) (result i32)
  (call $rael.get_len (local.get $arr)))
 (func $rael.array_item (param $arr i32) (param $index i32) (result i32)
  (call $rael.check_range (local.get $index) (i32.const 0)
   (i32.sub (call $rael.array_length (local.get $arr)) (i32.const 1)))
  (i32.load offset=4
   (i32.add (local.get $arr) (i32.mul (local.get $index) (i32.const 4)))))
 (func $rael.array_set_item (param $arr i32) (param $index i32)
  (param $val i32) (result i32)
  (call $rael.check_range (local.get $index) (i32.const 0)
   (i32.sub (call $rael.array_length (local.get $arr)) (i32.const 1)))
  (i32.store offset=4
   (i32.add (local.get $arr) (i32.mul (local.get $index) (i32.const 4)))
   (local.get $val))
  (i32.const 0))
 (func $rael.array_make (param $size i32) (param $val i32) (result i32)
  (local $arr i32) (local $counter i32)
  (if (i32.lt_s (local.get $size) (i32.const 0)) (then (unreachable)) (else))
  (local.set $arr
   (call $rael.gc.malloc (i32.mul (local.get $size) (i32.const 4))))
  (call $rael.set_len (local.get $arr) (local.get $size))
  (call $rael.set_tag (local.get $arr) (i32.const 0))
  (loop $loop
   (if (i32.lt_s (local.get $counter) (local.get $size))
    (then
     (i32.store offset=4
      (i32.add (local.get $arr) (i32.mul (local.get $counter) (i32.const 4)))
      (local.get $val))
     (local.set $counter (i32.add (local.get $counter) (i32.const 1)))
     (br $loop))
    (else)))
  (local.get $arr))
 (func $rael.compare_int (param $a i32) (param $b i32) (result i32)
  (if (result i32) (i32.eq (local.get $a) (local.get $b))
   (then (i32.const 0))
   (else
    (if (result i32) (i32.lt_s (local.get $a) (local.get $b))
     (then (i32.const -1)) (else (i32.const 1))))))
 (table $rael.global funcref (elem))
 (func $Canvas_ctx::begin_path.fn/12 (param $param/162 externref)
  (result i32) (local.get $param/162) (call $canvas.begin_path)
  (i32.const 0))
 (func $Canvas_ctx::set_stroke_style.fn/16 (param $param/160 externref)
  (param $param/161 i32) (result i32) (local.get $param/160)
  (local.get $param/161) (call $canvas.set_stroke_style) (i32.const 0))
 (func $Canvas_ctx::set_fill_style.fn/10 (param $param/158 externref)
  (param $param/159 i32) (result i32) (local.get $param/158)
  (local.get $param/159) (call $canvas.set_fill_style) (i32.const 0))
 (func $Canvas_ctx::move_to.fn/15 (param $param/155 externref)
  (param $param/156 i32) (param $param/157 i32) (result i32)
  (local.get $param/155) (local.get $param/156) (local.get $param/157)
  (call $canvas.move_to) (i32.const 0))
 (func $Canvas_ctx::line_to.fn/14 (param $param/152 externref)
  (param $param/153 i32) (param $param/154 i32) (result i32)
  (local.get $param/152) (local.get $param/153) (local.get $param/154)
  (call $canvas.line_to) (i32.const 0))
 (func $Canvas_ctx::stroke.fn/8 (param $param/151 externref) (result i32)
  (local.get $param/151) (call $canvas.stroke) (i32.const 0))
 (func $Canvas_ctx::fill_rect.fn/9 (param $param/146 externref)
  (param $param/147 i32) (param $param/148 i32) (param $param/149 i32)
  (param $param/150 i32) (result i32) (local.get $param/146)
  (local.get $param/147) (local.get $param/148) (local.get $param/149)
  (local.get $param/150) (call $canvas.fill_rect) (i32.const 0))
 (func $Universe::get_index.fn/11 (param $self/90 i32) (param $row/89 i32)
  (param $column/91 i32) (result i32) (local.get $row/89)
  (local.get $self/90) (i32.load offset=4) (i32.mul) (local.get $column/91)
  (i32.add))
 (func $new.fn/27 (export "new") (result i32) (local $width/92 i32)
  (local $height/93 i32) (local $cells/94 i32) (local $idx/95 i32)
  (local $ptr/163 i32) (i32.const 64) (local.set $width/92) (i32.const 64)
  (local.set $height/93) (local.get $width/92) (local.get $height/93)
  (i32.mul) (i32.const 10008) (call $rael.array_make) (local.set $cells/94)
  (i32.const 0) (local.set $idx/95)
  (block $block/165
   (loop $loop/164 (local.get $idx/95) (local.get $width/92)
    (local.get $height/93) (i32.mul) (call $rael.compare_int) (i32.const 0)
    (i32.lt_s)
    (if
     (then
      (block (result i32) (i32.const 1) (local.get $idx/95) (i32.const 2)
       (i32.rem_s) (i32.const 0) (i32.eq) (br_if 0) (drop)
       (local.get $idx/95) (i32.const 7) (i32.rem_s) (i32.const 0) (i32.eq))
      (if (result i32)
       (then (local.get $cells/94) (local.get $idx/95) (i32.const 10000)
        (call $rael.array_set_item))
       (else (local.get $cells/94) (local.get $idx/95) (i32.const 10008)
        (call $rael.array_set_item)))
      (drop) (local.get $idx/95) (i32.const 1) (i32.add) (local.set $idx/95)
      (i32.const 0) (br $loop/164)))))
  (i32.const 12) (call $rael.gc.malloc) (local.tee $ptr/163) (i32.const 0)
  (call $rael.set_tag) (local.get $ptr/163) (i32.const 3)
  (call $rael.set_len) (local.get $ptr/163) (local.get $cells/94)
  (i32.store offset=12) (local.get $ptr/163) (local.get $height/93)
  (i32.store offset=8) (local.get $ptr/163) (local.get $width/92)
  (i32.store offset=4) (local.get $ptr/163))
 (func $Universe::get_width.fn/25 (export "Universe::get_width")
  (param $self/96 i32) (result i32) (local.get $self/96) (i32.load offset=4))
 (func $Universe::get_height.fn/23 (export "Universe::get_height")
  (param $self/97 i32) (result i32) (local.get $self/97) (i32.load offset=8))
 (func $Universe::get_cell.fn/20 (param $self/99 i32) (param $idx/100 i32)
  (result i32) (local $bind/98 i32) (local $tag/166 i32) (local.get $self/99)
  (i32.load offset=12) (local.get $idx/100) (call $rael.array_item)
  (local.tee $bind/98) (call $rael.get_tag) (local.set $tag/166)
  (if (result i32) (i32.eq (local.get $tag/166) (i32.const 1))
   (then (i32.const 1)) (else (i32.const 0))))
 (func $Universe::live_neighbor_count.fn/18 (param $self/103 i32)
  (param $row/108 i32) (param $column/110 i32) (result i32)
  (local $count/101 i32) (local $delta_rows/102 i32)
  (local $delta_cols/104 i32) (local $r/105 i32) (local $c/106 i32)
  (local $neighbor_row/107 i32) (local $neighbor_col/109 i32)
  (local $idx/111 i32) (local $ptr/171 i32) (local $ptr/172 i32)
  (i32.const 0) (local.set $count/101) (i32.const 3) (i32.const 0)
  (call $rael.array_make) (local.tee $ptr/172) (local.get $self/103)
  (i32.load offset=8) (i32.const 1) (i32.sub) (i32.store offset=4)
  (local.get $ptr/172) (i32.const 0) (i32.store offset=8)
  (local.get $ptr/172) (i32.const 1) (i32.store offset=12)
  (local.get $ptr/172) (local.set $delta_rows/102) (i32.const 3)
  (i32.const 0) (call $rael.array_make) (local.tee $ptr/171)
  (local.get $self/103) (i32.load offset=4) (i32.const 1) (i32.sub)
  (i32.store offset=4) (local.get $ptr/171) (i32.const 0)
  (i32.store offset=8) (local.get $ptr/171) (i32.const 1)
  (i32.store offset=12) (local.get $ptr/171) (local.set $delta_cols/104)
  (i32.const 0) (local.set $r/105)
  (block $block/168
   (loop $loop/167 (local.get $r/105) (i32.const 3) (call $rael.compare_int)
    (i32.const 0) (i32.lt_s)
    (if
     (then (i32.const 0) (local.set $c/106)
      (block $block/170
       (loop $loop/169 (local.get $c/106) (i32.const 3)
        (call $rael.compare_int) (i32.const 0) (i32.lt_s)
        (if
         (then
          (block (result i32) (i32.const 0) (local.get $delta_rows/102)
           (local.get $r/105) (call $rael.array_item) (i32.const 0) (i32.eq)
           (i32.eqz) (br_if 0) (drop) (local.get $delta_cols/104)
           (local.get $c/106) (call $rael.array_item) (i32.const 0) (i32.eq))
          (if (result i32)
           (then (local.get $c/106) (i32.const 1) (i32.add)
            (local.set $c/106) (br $loop/169))
           (else (i32.const 0)))
          (drop) (local.get $row/108) (local.get $delta_rows/102)
          (local.get $r/105) (call $rael.array_item) (i32.add)
          (local.get $self/103) (i32.load offset=8) (i32.rem_s)
          (local.set $neighbor_row/107) (local.get $column/110)
          (local.get $delta_cols/104) (local.get $c/106)
          (call $rael.array_item) (i32.add) (local.get $self/103)
          (i32.load offset=4) (i32.rem_s) (local.set $neighbor_col/109)
          (local.get $self/103) (local.get $neighbor_row/107)
          (local.get $neighbor_col/109) (call $Universe::get_index.fn/11)
          (local.set $idx/111) (local.get $count/101) (local.get $self/103)
          (local.get $idx/111) (call $Universe::get_cell.fn/20) (i32.add)
          (local.set $count/101) (local.get $c/106) (i32.const 1) (i32.add)
          (local.set $c/106) (i32.const 0) (br $loop/169)))))
      (local.get $r/105) (i32.const 1) (i32.add) (local.set $r/105)
      (i32.const 0) (br $loop/167)))))
  (local.get $count/101))
 (func $Universe::tick.fn/6 (param $self/113 i32) (result i32)
  (local $next/112 i32) (local $r/114 i32) (local $c/115 i32)
  (local $idx/116 i32) (local $cell/117 i32) (local $live_neighbor/118 i32)
  (local $next_cell/119 i32) (local $c/123 i32) (local $bind/124 i32)
  (local $x/125 i32) (local $x/126 i32) (local $x/127 i32)
  (local $tag/177 i32) (local $ptr/178 i32) (local.get $self/113)
  (i32.load offset=4) (local.get $self/113) (i32.load offset=8) (i32.mul)
  (i32.const 10008) (call $rael.array_make) (local.set $next/112)
  (i32.const 0) (local.set $r/114)
  (block $block/174
   (loop $loop/173 (local.get $r/114) (local.get $self/113)
    (i32.load offset=8) (call $rael.compare_int) (i32.const 0) (i32.lt_s)
    (if
     (then (i32.const 0) (local.set $c/115)
      (block $block/176
       (loop $loop/175 (local.get $c/115) (local.get $self/113)
        (i32.load offset=4) (call $rael.compare_int) (i32.const 0) (i32.lt_s)
        (if
         (then (local.get $self/113) (local.get $r/114) (local.get $c/115)
          (call $Universe::get_index.fn/11) (local.set $idx/116)
          (local.get $self/113) (i32.load offset=12) (local.get $idx/116)
          (call $rael.array_item) (local.set $cell/117) (local.get $self/113)
          (local.get $r/114) (local.get $c/115)
          (call $Universe::live_neighbor_count.fn/18)
          (local.set $live_neighbor/118)
          (block (result i32)
           (block $join:120 (result i32)
            (block (result i32)
             (block $join:121 (result i32)
              (block (result i32)
               (block $join:122 (result i32) (i32.const 8)
                (call $rael.gc.malloc) (local.tee $ptr/178) (i32.const 0)
                (call $rael.set_tag) (local.get $ptr/178) (i32.const 2)
                (call $rael.set_len) (local.get $ptr/178)
                (local.get $live_neighbor/118) (i32.store offset=8)
                (local.get $ptr/178) (local.get $cell/117)
                (i32.store offset=4) (local.get $ptr/178)
                (local.tee $bind/124) (i32.load offset=4) (local.tee $x/125)
                (call $rael.get_tag) (local.set $tag/177)
                (if (result i32) (i32.eq (local.get $tag/177) (i32.const 1))
                 (then (local.get $bind/124) (i32.load offset=8)
                  (local.tee $x/126) (local.set $c/123) (i32.const 0)
                  (br $join:122))
                 (else (local.get $bind/124) (i32.load offset=8)
                  (local.tee $x/127) (i32.const 3) (i32.eq)
                  (if (result i32) (then (i32.const 0) (br $join:121))
                   (else (i32.const 0) (br $join:120)))))
                (br 1))
               (drop) (local.get $c/123) (i32.const 2)
               (call $rael.compare_int) (i32.const 0) (i32.lt_s)
               (if (result i32) (then (i32.const 10008))
                (else
                 (block (result i32) (i32.const 1) (local.get $c/123)
                  (i32.const 2) (i32.eq) (br_if 0) (drop) (local.get $c/123)
                  (i32.const 3) (i32.eq))
                 (if (result i32) (then (i32.const 10000))
                  (else (i32.const 10008))))))
              (br 1))
             (drop) (i32.const 10000))
            (br 1))
           (drop) (local.get $cell/117))
          (local.set $next_cell/119) (local.get $next/112)
          (local.get $idx/116) (local.get $next_cell/119)
          (call $rael.array_set_item) (drop) (local.get $c/115) (i32.const 1)
          (i32.add) (local.set $c/115) (i32.const 0) (br $loop/175)))))
      (local.get $r/114) (i32.const 1) (i32.add) (local.set $r/114)
      (i32.const 0) (br $loop/173)))))
  (local.get $self/113) (local.get $next/112) (i32.store offset=12)
  (i32.const 0))
 (func $Universe::draw_grid.fn/5 (param $self/130 i32)
  (param $canvas/128 externref) (param $cell_size/131 i32) (result i32)
  (local $c/129 i32) (local $r/132 i32) (local.get $canvas/128)
  (call $Canvas_ctx::begin_path.fn/12) (drop) (local.get $canvas/128)
  (i32.const 0) (call $Canvas_ctx::set_stroke_style.fn/16) (drop)
  (i32.const 0) (local.set $c/129)
  (block $block/182
   (loop $loop/181 (local.get $c/129) (local.get $self/130)
    (i32.load offset=4) (call $rael.compare_int) (i32.const 0) (i32.le_s)
    (if
     (then (local.get $canvas/128) (local.get $c/129)
      (local.get $cell_size/131) (i32.const 1) (i32.add) (i32.mul)
      (i32.const 1) (i32.add) (i32.const 0) (call $Canvas_ctx::move_to.fn/15)
      (drop) (local.get $canvas/128) (local.get $c/129)
      (local.get $cell_size/131) (i32.const 1) (i32.add) (i32.mul)
      (i32.const 1) (i32.add) (local.get $cell_size/131) (i32.const 1)
      (i32.add) (local.get $self/130) (i32.load offset=8) (i32.mul)
      (i32.const 1) (i32.add) (call $Canvas_ctx::line_to.fn/14) (drop)
      (local.get $c/129) (i32.const 1) (i32.add) (local.set $c/129)
      (i32.const 0) (br $loop/181)))))
  (i32.const 0) (local.set $r/132)
  (block $block/180
   (loop $loop/179 (local.get $r/132) (local.get $self/130)
    (i32.load offset=8) (call $rael.compare_int) (i32.const 0) (i32.le_s)
    (if
     (then (local.get $canvas/128) (i32.const 0) (local.get $r/132)
      (local.get $cell_size/131) (i32.const 1) (i32.add) (i32.mul)
      (i32.const 1) (i32.add) (call $Canvas_ctx::move_to.fn/15) (drop)
      (local.get $canvas/128) (local.get $cell_size/131) (i32.const 1)
      (i32.add) (local.get $self/130) (i32.load offset=4) (i32.mul)
      (i32.const 1) (i32.add) (local.get $r/132) (local.get $cell_size/131)
      (i32.const 1) (i32.add) (i32.mul) (i32.const 1) (i32.add)
      (call $Canvas_ctx::line_to.fn/14) (drop) (local.get $r/132)
      (i32.const 1) (i32.add) (local.set $r/132) (i32.const 0)
      (br $loop/179)))))
  (local.get $canvas/128) (call $Canvas_ctx::stroke.fn/8))
 (func $Universe::draw_cells.fn/4 (param $self/135 i32)
  (param $canvas/133 externref) (param $cell_size/141 i32) (result i32)
  (local $r/134 i32) (local $c/136 i32) (local $idx/137 i32)
  (local $cell/138 i32) (local $tag/187 i32) (local.get $canvas/133)
  (call $Canvas_ctx::begin_path.fn/12) (drop) (i32.const 0)
  (local.set $r/134)
  (block $block/184
   (loop $loop/183 (local.get $r/134) (local.get $self/135)
    (i32.load offset=8) (call $rael.compare_int) (i32.const 0) (i32.lt_s)
    (if
     (then (i32.const 0) (local.set $c/136)
      (block $block/186
       (loop $loop/185 (local.get $c/136) (local.get $self/135)
        (i32.load offset=4) (call $rael.compare_int) (i32.const 0) (i32.lt_s)
        (if
         (then (local.get $self/135) (local.get $r/134) (local.get $c/136)
          (call $Universe::get_index.fn/11) (local.set $idx/137)
          (local.get $self/135) (i32.load offset=12) (local.get $idx/137)
          (call $rael.array_item) (local.set $cell/138)
          (block (result i32)
           (block $join:139 (result i32)
            (block (result i32)
             (block $join:140 (result i32) (local.get $cell/138)
              (call $rael.get_tag) (local.set $tag/187)
              (if (result i32) (i32.eq (local.get $tag/187) (i32.const 1))
               (then (i32.const 0) (br $join:140))
               (else (i32.const 0) (br $join:139)))
              (br 1))
             (drop) (local.get $canvas/133) (i32.const 2)
             (call $Canvas_ctx::set_fill_style.fn/10))
            (br 1))
           (drop) (local.get $canvas/133) (i32.const 1)
           (call $Canvas_ctx::set_fill_style.fn/10))
          (drop) (local.get $canvas/133) (local.get $c/136)
          (local.get $cell_size/141) (i32.const 1) (i32.add) (i32.mul)
          (i32.const 1) (i32.add) (local.get $r/134)
          (local.get $cell_size/141) (i32.const 1) (i32.add) (i32.mul)
          (i32.const 1) (i32.add) (local.get $cell_size/141)
          (local.get $cell_size/141) (call $Canvas_ctx::fill_rect.fn/9)
          (drop) (local.get $c/136) (i32.const 1) (i32.add)
          (local.set $c/136) (i32.const 0) (br $loop/185)))))
      (local.get $r/134) (i32.const 1) (i32.add) (local.set $r/134)
      (i32.const 0) (br $loop/183)))))
  (local.get $canvas/133) (call $Canvas_ctx::stroke.fn/8))
 (func $Universe::render.fn/3 (export "Universe::render")
  (param $self/142 i32) (param $canvas/143 externref)
  (param $cell_size/144 i32) (result i32) (local.get $self/142)
  (call $Universe::tick.fn/6) (drop) (local.get $self/142)
  (local.get $canvas/143) (local.get $cell_size/144)
  (call $Universe::draw_grid.fn/5) (drop) (local.get $self/142)
  (local.get $canvas/143) (local.get $cell_size/144)
  (call $Universe::draw_cells.fn/4))
 (func $*init*/37) (export "_start" (func $*init*/37)))
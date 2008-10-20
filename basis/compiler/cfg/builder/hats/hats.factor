! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel cpu.architecture compiler.cfg.registers
compiler.cfg.instructions ;
IN: compiler.cfg.builder.hats

: i int-regs next-vreg ; inline
: ^^i i dup ; inline
: ^^i1 [ ^^i ] dip ; inline
: ^^i2 [ ^^i ] 2dip ; inline
: ^^i3 [ ^^i ] 3dip ; inline

: d double-float-regs next-vreg ; inline
: ^^d d dup ; inline
: ^^d1 [ ^^d ] dip ; inline
: ^^d2 [ ^^d ] 2dip ; inline
: ^^d3 [ ^^d ] 3dip ; inline

: ^^load-literal ( obj -- dst ) ^^i1 ##load-literal ; inline
: ^^peek ( loc -- dst ) ^^i1 ##peek ; inline
: ^^slot ( obj slot tag -- dst ) ^^i3 ##slot ; inline
: ^^slot-imm ( obj slot tag -- dst ) ^^i3 ##slot-imm ; inline
: ^^add ( src1 src2 -- dst ) ^^i2 ##add ; inline
: ^^add-imm ( src1 src2 -- dst ) ^^i2 ##add-imm ; inline
: ^^sub ( src1 src2 -- dst ) ^^i2 ##sub ; inline
: ^^sub-imm ( src1 src2 -- dst ) ^^i2 ##sub-imm ; inline
: ^^mul ( src1 src2 -- dst ) ^^i2 ##mul ; inline
: ^^mul-imm ( src1 src2 -- dst ) ^^i2 ##mul-imm ; inline
: ^^and ( input mask -- output ) ^^i2 ##and ; inline
: ^^and-imm ( input mask -- output ) ^^i2 ##and-imm ; inline
: ^^or ( src1 src2 -- dst ) ^^i2 ##or ; inline
: ^^or-imm ( src1 src2 -- dst ) ^^i2 ##or-imm ; inline
: ^^xor ( src1 src2 -- dst ) ^^i2 ##xor ; inline
: ^^xor-imm ( src1 src2 -- dst ) ^^i2 ##xor-imm ; inline
: ^^shl-imm ( src1 src2 -- dst ) ^^i2 ##shl-imm ; inline
: ^^shr-imm ( src1 src2 -- dst ) ^^i2 ##shr-imm ; inline
: ^^sar-imm ( src1 src2 -- dst ) ^^i2 ##sar-imm ; inline
: ^^not ( src -- dst ) ^^i1 ##not ; inline
: ^^bignum>integer ( src -- dst ) ^^i1 ##bignum>integer ; inline
: ^^integer>bignum ( src -- dst ) ^^i1 i ##integer>bignum ; inline
: ^^add-float ( src1 src2 -- dst ) ^^d2 ##add-float ; inline
: ^^sub-float ( src1 src2 -- dst ) ^^d2 ##sub-float ; inline
: ^^mul-float ( src1 src2 -- dst ) ^^d2 ##mul-float ; inline
: ^^div-float ( src1 src2 -- dst ) ^^d2 ##div-float ; inline
: ^^float>integer ( src -- dst ) ^^i1 ##float>integer ; inline
: ^^integer>float ( src -- dst ) ^^d1 i ##integer>float ; inline
: ^^allot ( size type tag -- dst ) ^^i3 i ##allot ; inline
: ^^write-barrier ( src -- ) i i ##write-barrier ; inline
: ^^box-float ( src -- dst ) ^^i1 i ##box-float ; inline
: ^^unbox-float ( src -- dst ) ^^d1 ##unbox-float ; inline
: ^^box-alien ( src -- dst ) ^^i1 i ##box-alien ; inline
: ^^unbox-alien ( src -- dst ) ^^i1 ##unbox-alien ; inline
: ^^unbox-c-ptr ( src class -- dst ) ^^i2 ##unbox-c-ptr ;
: ^^alien-unsigned-1 ( src -- dst ) ^^i1 ##alien-unsigned-1 ; inline
: ^^alien-unsigned-2 ( src -- dst ) ^^i1 ##alien-unsigned-2 ; inline
: ^^alien-unsigned-4 ( src -- dst ) ^^i1 ##alien-unsigned-4 ; inline
: ^^alien-signed-1 ( src -- dst ) ^^i1 ##alien-signed-1 ; inline
: ^^alien-signed-2 ( src -- dst ) ^^i1 ##alien-signed-2 ; inline
: ^^alien-signed-4 ( src -- dst ) ^^i1 ##alien-signed-3 ; inline
: ^^alien-cell ( src -- dst ) ^^i1 ##alien-cell ; inline
: ^^alien-float ( src -- dst ) ^^i1 ##alien-float ; inline
: ^^alien-double ( src -- dst ) ^^i1 ##alien-double ; inline

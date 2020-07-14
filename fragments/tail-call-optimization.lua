--
--	tail-call-optimization.lua
--
--	porting from:
--	https://github.com/justinethier/cyclone/blob/master/examples/tail-call-optimization.scm
--
--	> lua[jit] tail-call-optimization.lua
--	... running forever ...
--
--	> luac -l [-o nul or -o /dev/null] -- src
--	> luajit -bl src
--	> luajit -jdump src
--

local foo
local bar

function foo()
	return bar()
end

function bar()
	return foo()
end

foo()

--[=[	dumps (luac -l -o nul -- src) (Lua 5.4.0)
main <tail-call-optimization.lua:0,0> (9 instructions at 000001e332fe8530)
0+ params, 3 slots, 1 upvalue, 2 locals, 0 constants, 2 functions
        1       [1]     VARARGPREP      0
        2       [8]     LOADNIL         0 1     ; 2 out
        3       [13]    CLOSURE         2 0     ; 000001e332fe87c0
        4       [11]    MOVE            0 2
        5       [17]    CLOSURE         2 1     ; 000001e332fe8920
        6       [15]    MOVE            1 2
        7       [19]    MOVE            2 0
        8       [19]    CALL            2 1 1   ; 0 in 0 out
        9       [19]    RETURN          2 1 1   ; 0 out

function <tail-call-optimization.lua:11,13> (4 instructions at 000001e332fe87c0)
0 params, 2 slots, 1 upvalue, 0 locals, 0 constants, 0 functions
        1       [12]    GETUPVAL        0 0     ; bar
        2       [12]    TAILCALL        0 1 0   ; 0 in
        3       [12]    RETURN          0 0 0   ; all out
        4       [13]    RETURN0

function <tail-call-optimization.lua:15,17> (4 instructions at 000001e332fe8920)
0 params, 2 slots, 1 upvalue, 0 locals, 0 constants, 0 functions
        1       [16]    GETUPVAL        0 0     ; foo
        2       [16]    TAILCALL        0 1 0   ; 0 in
        3       [16]    RETURN          0 0 0   ; all out
        4       [17]    RETURN0
--]=]

--[=[	dumps (luajit -bl src) (LuaJIT 2.0.5)
-- BYTECODE -- tail-call-optimization.lua:11-13
0001    UGET     0   0      ; bar
0002    CALLT    0   1

-- BYTECODE -- tail-call-optimization.lua:15-17
0001    UGET     0   0      ; foo
0002    CALLT    0   1

-- BYTECODE -- tail-call-optimization.lua:0-27
0001    KNIL     0   1
0002    FNEW     0   0      ; tail-call-optimization.lua:11
0003    FNEW     1   1      ; tail-call-optimization.lua:15
0004    MOV      2   0
0005    CALL     2   1   1
0006    UCLO     0 => 0007
0007 => RET0     0   1
--]=]

--[=[	dumps (luajit -jdump src) (LuaJIT 2.0.5)
---- TRACE 1 start tail-call-optimization.lua:11
0001  UGET     0   0      ; bar
0002  CALLT    0   1
0000  FUNCF    1          ; tail-call-optimization.lua:15
0001  UGET     0   0      ; foo
0002  CALLT    0   1
0000  FUNCF    1          ; tail-call-optimization.lua:11
0001  UGET     0   0      ; bar
0002  CALLT    0   1
0000  FUNCF    1          ; tail-call-optimization.lua:15
0001  UGET     0   0      ; foo
0002  CALLT    0   1
0000  FUNCF    1          ; tail-call-optimization.lua:11
---- TRACE 1 IR
0001    fun SLOAD  #0    R
0002 >  p32 UREFO  0001  #0  
0003    p32 SUB    0002  0000
0004 >  p32 UGT    0003  +8  
0005 >  fun ULOAD  0002
0006 >  fun EQ     0005  tail-call-optimization.lua:15
0007 >  p32 UREFO  tail-call-optimization.lua:15  #0  
0008    p32 SUB    0007  0000
0009 >  p32 UGT    0008  +8  
0010 >  fun ULOAD  0007
0011 >  fun EQ     0010  tail-call-optimization.lua:11
0012 >  p32 UREFO  tail-call-optimization.lua:11  #0  
0013    p32 SUB    0012  0000
0014 >  p32 UGT    0013  +8  
0015 >  fun ULOAD  0012
0016 >  fun EQ     0015  tail-call-optimization.lua:15
0017 ------ LOOP ------------
---- TRACE 1 mcode 143
9f8dff63  mov dword [0x001404a0], 0x1
9f8dff6e  mov r8d, [rdx-0x8]
9f8dff72  mov edi, [r8+0x14]
9f8dff76  mov esi, [rdi+0x10]
9f8dff79  mov edi, esi
9f8dff7b  sub edi, edx
9f8dff7d  cmp edi, +0x08
9f8dff80  jbe 0x9f8d0010	->0
9f8dff86  cmp dword [rsi+0x4], -0x09
9f8dff8a  jnz 0x9f8d0010	->0
9f8dff90  cmp dword [rsi], 0x00148c98
9f8dff96  jnz 0x9f8d0010	->0
9f8dff9c  mov ebx, [0x00149d50]
9f8dffa3  mov ebp, ebx
9f8dffa5  sub ebp, edx
9f8dffa7  cmp ebp, +0x08
9f8dffaa  jbe 0x9f8d0010	->0
9f8dffb0  cmp dword [rbx+0x4], -0x09
9f8dffb4  jnz 0x9f8d0010	->0
9f8dffba  cmp dword [rbx], 0x0015f268
9f8dffc0  jnz 0x9f8d0010	->0
9f8dffc6  mov eax, [0x001504a8]
9f8dffcd  mov ecx, eax
9f8dffcf  sub ecx, edx
9f8dffd1  cmp ecx, +0x08
9f8dffd4  jbe 0x9f8d0010	->0
9f8dffda  cmp dword [rax+0x4], -0x09
9f8dffde  jnz 0x9f8d0010	->0
9f8dffe4  cmp dword [rax], 0x00148c98
9f8dffea  jnz 0x9f8d0010	->0
->LOOP:
9f8dfff0  jmp 0x9f8dfff0	->LOOP
---- TRACE 1 stop -> tail-recursion
--]=]

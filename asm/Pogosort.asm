; --------------------------------
.DATA


.CODE

; Procedure invoked upon entering the Dll for the first time
DllEntry proc

mov EAX, 1
ret

DllEntry endp


; Bubblesort
; Simplest sorting algorithm, which only swaps two adjacent elements repeatedly, until the array is sorted.
; Each loop iteration usually only puts one element in the right place.
; Worst complexity: n^2
; Average complexity: n^2
BubbleSort proc

; RCX - pointer to array
; RDX - number of elements in array

xor R8D, R8D	; i

OuterLoop:

	xor R9D, R9D	; j
	
InnerLoop:
	mov R10D, [RCX + 4 * R9]
	mov R11D, [RCX + 4 * R9 + 4]
	
	cmp R10D, R11D
	jle InnerLoopIter
	
	mov [RCX + 4 * R9 + 4], R10D
	mov [RCX + 4 * R9], R11D
	
InnerLoopIter:
	inc R9D
	
	mov R10D, EDX
	sub R10D, R8D
	dec R10D
	
	cmp R9D, R10D
	jl InnerLoop
	
	jmp OuterLoopIter
	
OuterLoopIter:
	inc R8D
	
	mov R11D, EDX
	dec R11D
	
	cmp R8D, R11D
	jl OuterLoop
	
	jmp AlgorithmEnd
	
AlgorithmEnd:
	mov RAX, RCX
	ret

BubbleSort endp

END
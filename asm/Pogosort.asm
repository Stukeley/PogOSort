; --------------------------------
; https://github.com/Stukeley/PogOSort
; Algorithm sources:
; https://en.wikipedia.org/
; https://www.geeksforgeeks.org/
; https://www.youtube.com/c/WhatsACreel

.DATA

Divisor DWORD 13897
Term DWORD 9521
MaxIterations DWORD 1000000
BytesPerInt DWORD 4

GapSequence DWORD 1750, 701, 301, 132, 57, 23, 10, 4, 1

.CODE

; Procedure invoked upon entering the Dll for the first time
DllEntry proc

mov EAX, 1
ret

DllEntry endp

; --- Quadratic Sorting Algorithms --- ;

; Bubble Sort
; Simplest sorting algorithm, which only swaps two adjacent elements repeatedly, until the array is sorted.
; Each loop iteration usually only puts one element in the right place.
; Worst complexity: n^2
; Average complexity: n^2
BubbleSort proc

; RCX - pointer to array
; RDX - number of elements in array

xor R8D, R8D	; i

BubbleSort_OuterLoop:

	xor R9D, R9D	; j
	
BubbleSort_InnerLoop:
	mov R10D, dword ptr [RCX + 4 * R9]
	mov R11D, dword ptr [RCX + 4 * R9 + 4]
	
	cmp R10D, R11D
	jle BubbleSort_InnerLoopIter
	
	mov [RCX + 4 * R9 + 4], R10D
	mov [RCX + 4 * R9], R11D
	
BubbleSort_InnerLoopIter:
	inc R9D
	
	mov R10D, EDX
	sub R10D, R8D
	dec R10D
	
	cmp R9D, R10D
	jl BubbleSort_InnerLoop
	
	jmp BubbleSort_OuterLoopIter
	
BubbleSort_OuterLoopIter:
	inc R8D
	
	mov R11D, EDX
	dec R11D
	
	cmp R8D, R11D
	jl BubbleSort_OuterLoop
	
	jmp BubbleSort_AlgorithmEnd
	
BubbleSort_AlgorithmEnd:
	mov RAX, RCX
	ret

BubbleSort endp


; Selection Sort
; Very similar to Bubble Sort, selects the smallest element of the array in each iteration, then puts it in the right place.
; Unlike Bubble Sort, however, the complexity of Selection Sort will almost always be of n^2, because regardless of the distribution in array,
; we will always have to make (n - 1) + (n - 2) + ... + 1 comparisons, which is of n^2 order.
; Worst complexity: n^2
; Average complexity: n^2
SelectionSort proc

xor R8D, R8D	; i

SelectionSort_OuterLoop:

	mov R9D, R8D	; j = i + 1
	inc R9D

	mov R10D, R8D	; min item index

SelectionSort_InnerLoop:

	mov R11D, dword ptr [RCX + 4 * R9]		; arr[j]
	mov R12D, dword ptr [RCX + 4 * R10]		; arr[min_index]

	cmp R11D, R12D

	jge SelectionSort_InnerLoopIter

	mov R10D, R9D

SelectionSort_InnerLoopIter:

	inc R9D

	cmp R9D, EDX

	jl SelectionSort_InnerLoop

SelectionSort_OuterLoopIter:

	; Swap item at min index with item at i

	mov R14D, dword ptr [RCX + 4 * R10]
	mov R15D, dword ptr [RCX + 4 * R8]

	mov [RCX + 4 * R10], R15D
	mov [RCX + 4 * R8], R14D

	inc R8D

	mov EAX, EDX
	sub EAX, 1	; RAX = n - 1

	cmp R8D, EAX

	jl SelectionSort_OuterLoop

SelectionSort_AlgorithmEnd:

	mov RAX, RCX
	ret

SelectionSort endp


; Insertion Sort
; One of the simplest sorting algorithms, sorts one item at a time.
; In each iteration, it places one item from the array in the correct place.
; Unlike Selection Sort, it does not look for the smallest element in each iteration, but instead places the next element in array in the correct spot.
; Worst complexity: n^2
; Average complexity: n^2
InsertionSort proc

; RCX - pointer to array
; RDX - number of elements in array

xor R8D, R8D	; i

InsertionSort_OuterLoop:
	
	mov R9D, R8D	; j
	inc R9D

InsertionSort_InnerLoop:

	mov R15D, dword ptr [RCX + 4 * R9]	; arr[j]
	mov R14D, dword ptr [RCX + 4 * R9 - 4]	; arr[j-1]

	cmp R14D, R15D

	jg InsertionSort_Swap

	jmp InsertionSort_InnerLoopIter

InsertionSort_Swap:
	mov [RCX + 4 * R9], R14D
	mov [RCX + 4 * R9 - 4], R15D

InsertionSort_InnerLoopIter:

	dec R9D

	cmp R9D, 0
	jle InsertionSort_OuterLoopIter

	jmp InsertionSort_InnerLoop

InsertionSort_OuterLoopIter:

	inc R8D

	mov R10D, EDX
	dec R10D	; n-1

	cmp R8D, R10D
	jl InsertionSort_OuterLoop

InsertionSort_AlgorithmEnd:
	mov RAX, RCX
	ret

InsertionSort endp

; Shell Sort
; Quite similar to Insertion or Bubble Sort, Shell Sort exchanges items in the array.
; The idea is to make it so that taking every h-th number in the array produces a sorted array.
; Gap sequence used: A102549, Marcin Ciura; 1, 4, 10, 23, 57, 132, 301, 701, 1750
; Worst complexity: n^2
; Average complexity: n logn
ShellSort proc

; RCX - pointer to array
; RDX - number of elements in array

; Get first gap value (it's the first one in array that is less than array size)
xor R15D, R15D

ShellSort_PrepLoop:
	lea R9, GapSequence
	mov R8D, dword ptr [R9 + 4 * R15]

	cmp R8D, EDX
	jl ShellSort_OuterLoop
	
	inc R15D
	jmp ShellSort_PrepLoop

ShellSort_OuterLoop:
	lea R8, GapSequence
	mov R14D, dword ptr [R8 + 4 * R15]	; R14D - current gap value

	mov R9D, R14D	; i = gap

ShellSort_InnerLoop: 
	

ShellSort_SecondInnerLoop:

ShellSort_SecondInnerLoopIter:

ShellSort_InnerLoopIter:

ShellSort_OuterLoopIter:
	inc R15D

	cmp R15D, 8	; 9 elements in the gap values array
	jg ShellSort_AlgorithmEnd

	jmp ShellSort_OuterLoop

ShellSort_AlgorithmEnd:
	mov RCX, RAX
	ret


ShellSort endp

; --- Logarithmic Sorting Algorithms --- ;

; --- Linear Sorting Algorithms --- ;

; --- Esoteric Sorting Algorithms --- ;

; Bogo Sort
; An esoteric sorting algorithm which orders items in an array (pseudo-)randomly.
; There is no guarantee the algorithm will always succeed.
; There is a maximum number of iterations this procedure will perform, after which the result will be returned no matter what.
; Worst complexity: infinite
; Average complexity: (n+1)!
; Best complexity: n
BogoSort proc

; RCX - pointer to array
; RDX - number of elements in array

push RCX
push RDX

; Saves low 32 bits of timestamp counter to EAX - we'll use that as random seed
RDTSCP

pop RCX
pop RDX

; TODO - wymyslic shuffle algorithm

BogoSort endp

; Is Sorted
; Helper function used by several algorithms, eg. Pogo Sort.
; Returns the information whether an array is sorted or not.
; Expects the following parameters: array pointer (in RCX), array length (in RDX)
IsSortedAsm proc

push R9
push R10
push R11

xor R9D, R9D
dec RDX

IsSorted_Loop:
	mov R10D, dword ptr [RCX + 4 * R9]
	mov R11D, dword ptr [RCX + 4 * R9 + 4]

	cmp R10D, R11D

	jg IsSorted_False

IsSorted_LoopIter:
	inc R9D

	cmp R9D, EDX
	jl IsSorted_Loop

	jmp IsSorted_True
	
IsSorted_False:
	mov RAX, 0
	jmp IsSorted_End

IsSorted_True:
	mov RAX, 1

IsSorted_End:
	inc RDX
	pop R11
	pop R10
	pop R9

	ret

IsSortedAsm endp


END
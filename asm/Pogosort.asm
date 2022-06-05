; --------------------------------
; https://github.com/Stukeley/PogOSort
; Algorithm sources:
; https://en.wikipedia.org/
; https://www.geeksforgeeks.org/
; https://www.youtube.com/c/WhatsACreel

.DATA

extern malloc: proc
extern free: proc

Divisor DWORD 13897
Term DWORD 9521
MaxIterations DWORD 100000
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
	mov R14D, dword ptr [R8 + 4 * R15]	; R14D - gap value

	xor R9D, R9D	; R9D - i

ShellSort_InnerLoop: 
	
	mov R10D, R9D	; R10D - j = i
	mov R11D, dword ptr [RCX + 4 * R9]	; R11D - arr[i] - tempValue

	; if (j >= gap) && (arr[j - gap] > tempValue), get in the loop

	cmp R10D, R14D	; j >= gap
	jl ShellSort_InnerLoopIter

	mov EAX, R10D
	sub EAX, R14D

	mov R12D, dword ptr [RCX + 4 * RAX]	; arr[j - gap]

	cmp R12D, R11D
	jle ShellSort_InnerLoopIter

ShellSort_SecondInnerLoop:

	; arr[j] = arr[j - gap]
	mov EAX, R10D

	mov R13D, dword ptr [RCX + 4 * RAX] ; R13D = arr[j]

	mov EAX, R10D
	sub EAX, R14D

	mov R12D, dword ptr [RCX + 4 * RAX]	; R14D = arr[j - gap]

	; swap
	mov [RCX + 4 * RAX], R13D
	mov [RCX + 4 * RAX], R12D

	; j = j - gap
	sub R10D, R14D

ShellSort_SecondInnerLoopIter:

	; if not (j >= gap) && (arr[j - gap] > tempValue), break out of this loop

	cmp R10D, R14D	; j >= gap
	jl ShellSort_InnerLoopIter

	mov R12D, dword ptr [RCX + 4 * RAX]	; arr[j - gap]

	cmp R12D, R11D
	jle ShellSort_InnerLoopIter

	jmp ShellSort_SecondInnerLoop

ShellSort_InnerLoopIter:

	; arr[j] = tempValue;
	mov [RCX + 4 * R10], R11D

ShellSort_OuterLoopIter:
	inc R15D

	cmp R15D, 8	; 9 elements in the gap values array
	jg ShellSort_AlgorithmEnd

	jmp ShellSort_OuterLoop

ShellSort_AlgorithmEnd:
	mov RAX, RCX
	ret


ShellSort endp

; --- Logarithmic Sorting Algorithms --- ;

MergeSort proc

MergeSort endp

QuickSort proc

QuickSort endp

; --- Linear Sorting Algorithms --- ;

; Counting Sort
; Counting Sort is a simple linear algorithm which uses a secondary array to sort the input. It only goes through the array once.
; As the name suggests, it counts the elements in input array, and stores the counts in second array.
; Then, it recreates the array using the stored counts - that will be the output.
; It is NOT a comparison sort. It requires some additional memory - the bigger values in input array, the more memory.
; Worst complexity: n + r, where r - range of key values
; Average complexity: n + r, where r - range of key values
CountingSort proc

; RCX - pointer to input array
; RDX - array size

; Preserve original parameters
mov R14, RCX
mov R15, RDX

; Allocate an array of 101 elements of 4 bytes each (our input data is in range of 1-100)
mov RCX, 404

;! Important - need to sub 32 from RSP before each CALL, and add 32 right after
; This is due to Windows x64 shallow space - functions can step on the 32 bytes above their return address
; Without doing this, we would get an access violation upon returning from the function
sub RSP, 32

call malloc	; Pointer to new array is in RAX

add RSP, 32

xor R10, R10	; Temporary iterator

; Set all values in array to 0
CountingSort_PrepLoop:

	mov dword ptr [RAX + 4 * R10], 0

	inc R10

	cmp R10, 101
	jl CountingSort_PrepLoop

; Count items in array
; The value is the index in created array

xor R10, R10	; i

CountingSort_FirstLoop:

	mov R11D, dword ptr [R14 + 4 * R10]	; arr[i]

	mov R12D, dword ptr [RAX + 4 * R11]	; counts[arr[i]]
	inc R12D	; ++
	mov [RAX + 4 * R11], R12D	; move back to array

CountingSort_FirstLoopIter:

	inc R10

	cmp R10, R15

	jl CountingSort_FirstLoop

	xor R10, R10	; i	- input array index
	xor R11, R11	; j - counts array index

CountingSort_SecondLoop:

	mov R12D, dword ptr [RAX + 4 * R11]	; value at counts[j]

	; if counts[j] = 0, skip to next iteration already

	cmp R12D, 0
	je CountingSort_SecondLoopIter

	; Insert (j) value counts[j] times (eg.: if j=1, counts[j] = 3, insert the value 1 three times)

CountingSort_SecondLoop_InnerLoop:
	
	mov [R14 + 4 * R10], R11D	; arr[i] = j
	inc R10	; i++

CountingSort_SecondLoop_InnerLoopIter:

	dec R12D

	cmp R12D, 0
	jne CountingSort_SecondLoop_InnerLoop

CountingSort_SecondLoopIter:

	inc R11

	cmp R11, 101
	jl CountingSort_SecondLoop

CountingSort_AlgorithmEnd:

	; Free the allocated array at the end of algorithm
	mov RCX, RAX

	sub RSP, 32

	call free

	add RSP, 32

	mov RAX, R14
	ret

CountingSort endp

; Radix Sort
; Quite similar to Counting Sort, but performs several iterations on the data.
; Each iteration, the input array is sorted by one digit. After going through all digits, the array is sorted.
; Because of the nature of Counting Sort (requires a second array of size based on values in array), Radix Sort will perform better if input
; values are much larger (and diverse) than the array size.
; Worst complexity: n * k, where k - max number of digits in values
; Average complexity: n * k, where k - max number of digits in values
RadixSort proc

; RCX - pointer to input array
; RDX - array size

; Preserve original parameters
mov R14, RCX
mov R15, RDX

; Allocate an array of 10 elements of 4 bytes each (one for each digit, 0-9)
mov RCX, 40

;! Important - need to sub 32 from RSP before each CALL, and add 32 right after
; This is due to Windows x64 shallow space - functions can step on the 32 bytes above their return address
; Without doing this, we would get an access violation upon returning from the function
sub RSP, 32

call malloc	; Pointer to new array is in RAX

add RSP, 32

xor R8, R8	; i

; Set all values in array to 0
RadixSort_PrepLoop:

	mov dword ptr [RAX + 4 * R8], 0

	inc R8

	cmp R8, 10
	jl RadixSort_PrepLoop

; TODO

RadixSort endp

; --- Esoteric Sorting Algorithms --- ;

; Dictator Sort
; An esoteric sorting algorithm, in which all elements not in order are removed from the array.
; Source: https://github.com/gustavo-depaula/stalin-sort
; Average complexity: n
; Warning: array may (will) be changed in process
DictatorSort proc

; RCX - pointer to input array
; RDX - array size

xor R8, R8	; i

xor R9, R9	; max value

xor R15, R15	; count

DictatorSort_Loop:

	mov R10D, dword ptr [RCX + 4 * R8]	; temp value

	cmp R10D, R9D

	jge DictatorSort_Loop_GreaterEqual

	jmp DictatorSort_Loop_Less

; Keep the element in the array, replace max value
DictatorSort_Loop_GreaterEqual:

	mov R9D, R10D
	inc R15		; count++

	jmp DictatorSort_LoopIter

; Remove the element from the array (for now set to 0)
DictatorSort_Loop_Less:

	mov dword ptr [RCX + 4 * R8], 0

DictatorSort_LoopIter:
	
	inc R8

	cmp R8D, EDX
	jl DictatorSort_Loop

DictatorSort_AlgorithmEnd:

	; Recreate the array - size equal to the count above + 1 (we'll put a zero at the end so that we can know how large the array is)

	mov R13, RCX	; original array
	mov R14, RDX	; n

	mov RCX, R15
	inc RCX
	shl RCX, 2	; amount of bytes to allocate: 4 * (count + 1)

	sub RSP, 32

	call malloc

	add RSP, 32
	
	xor R8, R8	; original array index
	xor R9, R9	; second array index

DictatorSort_OutputLoop:

	mov R10D, dword ptr [R13 + 4 * R8]

	cmp R10D, 0
	je DictatorSort_OutputLoopIter

	mov [RAX + 4 * R9], R10D
	inc R9

DictatorSort_OutputLoopIter:

	inc R8

	cmp R8, R14
	jl DictatorSort_OutputLoop

DictatorSort_AlgorithmRet:

	; Add zero to the end of the output array
	mov dword ptr [RAX + 4 * R9], 0

	mov RAX, RAX
	ret

DictatorSort endp


; Bogo Sort
; An esoteric sorting algorithm which orders items in an array (pseudo-)randomly.
; There is no guarantee the algorithm will always succeed.
; There is a maximum number of iterations this procedure will perform, after which the result will be returned no matter what.
; Uses the Sattolo's algorithm for shuffling array.
; Worst complexity: infinite
; Average complexity: (n+1)!
; Best complexity: n
BogoSort proc

xor R13, R13	; Number of iterations of algorithm - maximum number is defined in .data

; RCX - pointer to array
; RDX - number of elements in array
BogoSort_AlgorithmStart:

	mov R14, RCX	; R14 - pointer to array
	mov R15, RDX	; R15 - array length

	; Saves low 32 bits of timestamp counter to EAX - we'll use that as random seed
	RDTSCP

	; i = n <- R10
	mov R10, R15

BogoSort_Loop:

	; 1. i = i - 1
	; 2. j - randomize a number - range <0; i-1> (i = length)
	; randomize - divide the pseudo-random number returned by RDTSCP (seed) by (i) and take the remainder (it will be in range of 0 - i-1)
	; 3. swap i-th item with j-th item
	; 4. repeat while i > 1

	dec R10

	; pseudo-random value is in RAX
	mov RDX, 0	; we divide RDX:RAX compound register, so let's make RDX 0
	div R10

	; remainder stored in RDX

	; swap elements at [RDX] and [R10]
	mov R11D, dword ptr [R14 + 4 * RDX]
	mov R12D, dword ptr [R14 + 4 * R10]

	mov [R14 + 4 * RDX], R12D
	mov [R14 + 4 * R10], R11D

BogoSort_LoopIter:

	; loop until i <= 1

	cmp R10, 1
	jg BogoSort_Loop

BogoSort_AlgorithmEnd:

	; check if array is sorted
	mov RCX, R14
	mov RDX, R15
	call IsSortedAsm

	cmp RAX, 1
	je BogoSort_Sorted
	
BogoSort_NotSorted:

	; increment number of iterations, stored in R13
	inc R13D
	
	; check if we reached the maximum number of iterations - MaxIterations
	cmp R13D, MaxIterations

	; if not, go back to the start
	jl BogoSort_AlgorithmStart

BogoSort_Sorted:

	; array is sorted (or maximum number of iterations reached) - return the number of iterations
	mov RAX, R13
	ret

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
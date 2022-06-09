<p align="center">
  <img src="pogosort.png?raw=true">
</p>

# PogoSort

## What is PogoSort
PogoSort is a collection of sorting algorithms written in x64 ASM. Specifically, the assembler used is Microsoft Macro Assembler (MASM) in x64 mode. All procedures required for the algorithms to run were written by hand in ASM (except `malloc` and `free`, which are extern). All algorithms are run, displayed and evaluated directly in C.

### PogoSort consists of:
- **Quadratic Sorting Algorithms**: Bubble Sort, Selection Sort, Insertion Sort, Shell Sort
- **Logarithmic Sorting Algorithms**: Merge Sort, Quick Sort
- **Linear Sorting Algorithms**: Counting Sort, Radix Sort
- **Esoteric Sorting Algorithms**: [Dictator Sort](https://github.com/gustavo-depaula/stalin-sort), Bogo Sort

## Project structure

The project consists of these main directories:
- **/asm/** - contains the ASM source file (all algorithms are contained within a single file) as well as a DEF file that contains exported function definitions
- **/c/headers** - header files, including a header with all extern (exported from ASM) function definitions
- **/c/sources** - C source files

## Who is PogoSort for

PogoSort can mostly prove useful for students, either those who need to implement certain sorting algorithms in a low level language that x64 ASM is; or those, who are just learning assembly and need a little bit of help.

I strongly discourage copying the code implemented in this repository directly. It is better to instead use it as a learning resource, or as a reference - learning is easiest when you write your own code. This project contains some working algorithms that you can compare your code to if something isn't quite right.

## Is this significantly better than algorithms written in [insert language here]?

Short answer - **most likely not**.

To quote the legendary [Creel](https://youtu.be/8_0tbkbSGRE?t=31), "unless you're staying in Assembly language for millions of cycles, the overheads for calling a function and jumping to Assembly will be enough to make your function not worth it".

This is mostly to the amount of time it takes to call an external function; just simply calling ASM procedures from a higher-level language takes more time than it would to invoke a function written in that same language.

On top of that, by writing code directly in ASM we get rid of compiler optimizations - when higher level code (eg. C) is compiled and translated to an assembly language, the translation is not direct, it is not just translating an instruction to its assembly counterpart. The compiler often uses tricks to improve code performance, especially when dealing with loops, branches or internal procedure calls. You can read more about compiler optimizations [here](https://www.ibm.com/docs/en/aix/7.1?topic=tuning-compiler-optimization-techniques).

Therefore, it's unlikely that simply plugging in this code as a replacement for sorting algorithms written in a higher-level language will be a performance increase.

## Why no SIMD?

Firstly and most importantly - **it would go against the idea of this project**. The algorithms presented here and more-or-less direct translations of algorithms written in other languages, and they are not "newly invented" nor modified in any meaningful way from their theoretical versions. For example, if Bubble Sort compares two adjacent elements and swaps them if necessary, it would be a completely different algorithm if we performed that operation in batches of four, or more, elements at the same time, instead of checking them one by one.

Secondly - in my opinion, using SIMD for this project would be quite awkward. While SIMD instructions certainly have better performance than their scalar counterparts, the amount of time and lines of code it would take to prepare and consume a vector would likely neglect any gained performance. And, on top of that, it's almost impossible to have our input arrays always have a number of elements divisible by 4 (or 8, or 16, depending on which instruction set we would use), and consuming the last few elements that "did not fit in a vector" would be even more costly.

## Why use int32_t in C instead of just int?

**To ensure all integers are 32 bits in size.** If we just used int, and the program was run on a more "exotic" machine, or if we used a compiler that is not among the popular ones, not only would the application not work at all, but it could seriously damage our memory. The code written in ASM assumes all numbers are 32-bit integers, and using int32_t helps us ensure that.

## Sources

Resources used to create this project (also listed at the top of the ASM source file):

- https://en.wikipedia.org/
- https://www.geeksforgeeks.org/
- https://www.w3resource.com/
- https://www.youtube.com/c/WhatsACreel

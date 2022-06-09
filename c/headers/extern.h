//
// Created by Rafał Klinowski on 30.05.2022.
//

#ifndef POGOSORT_EXTERN_H
#define POGOSORT_EXTERN_H

#include <stdint.h>

extern void BubbleSort(int32_t* arr, int32_t n);
extern void SelectionSort(int32_t* arr, int32_t n);
extern void InsertionSort(int32_t* arr, int32_t n);
extern void ShellSort(int32_t* arr, int32_t n);
extern void CountingSort(int32_t* arr, int32_t n);
extern void MergeSort(int32_t* arr, int32_t left, int32_t right);
extern void QuickSort(int32_t* arr, int32_t left, int32_t right);
extern int32_t* DictatorSort(int32_t* arr, int32_t n);
extern int32_t BogoSort(int32_t* arr, int32_t n);

#endif //POGOSORT_EXTERN_H

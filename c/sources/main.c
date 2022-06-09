#include <stdio.h>
#include <stdbool.h>
#include "../headers/DataGeneration.h"
#include "../headers/extern.h"
#include "../headers/PrintArray.h"
#include "../headers/IsSorted.h"

#define N 100
#define FCOUNT 6    // Number of "generic" functions which don't have a return type and take only two parameters

int main() 
{
    int32_t* arr = GenerateArray(N);

    // https://stackoverflow.com/questions/252748/how-can-i-use-an-array-of-function-pointers
    void (*sorts[FCOUNT]) (int32_t * arr, int32_t n);

    sorts[0] = BubbleSort;
    sorts[1] = InsertionSort;
    sorts[2] = SelectionSort;
    sorts[3] = CountingSort;
    sorts[4] = ShellSort;
    sorts[5] = RadixSort;

    for (int i =0;i<FCOUNT;i++)
    {
        char* sortName = 0;

        switch (i)
        {
            case 0:
                sortName = "Bubble Sort";
                break;

            case 1:
                sortName = "Insertion Sort";
                break;

            case 2:
                sortName = "Selection Sort";
                break;

            case 3:
                sortName = "Counting Sort";
                break;

            case 4:
                sortName = "Shell Sort";
                break;

            case 5:
                sortName = "Radix Sort";
                break;

            default:
                sortName = "Unlisted sort";
                break;
        }

        printf("Sorting Algorithm: %s\n\n", sortName);

        int32_t* copy = malloc(N * sizeof(int32_t));
        memcpy(copy, arr, N * sizeof(int32_t));

        printf("Before:\n");

        PrintArray(copy, N);

        printf("\nAfter:\n");

        (*sorts[i])(copy, N);

        PrintArray(copy, N);

        bool isArraySorted = IsSorted(copy, N);

        printf("\nIsArraySorted: %s\n\n", isArraySorted ? "true" : "false");

        printf("---------------------\n\n");
        
        free(copy);
    }

    // Merge Sort is separate as it takes more parameters.
    {
        printf("Sorting Algorithm: Merge Sort\n\n");

        int32_t* copy = malloc(N * sizeof(int32_t));
        memcpy(copy, arr, N * sizeof(int32_t));

        printf("Before:\n");

        PrintArray(copy, N);

        printf("\nAfter:\n");

        MergeSort(copy, 0, N - 1);

        PrintArray(copy, N);

        bool isArraySorted = IsSorted(copy, N);

        printf("\nIsArraySorted: %s\n\n", isArraySorted ? "true" : "false");

        printf("---------------------\n\n");

        free(copy);
    }

    // Quick Sort is separate as it takes more parameters.
    {
        printf("Sorting Algorithm: Quick Sort\n\n");

        int32_t* copy = malloc(N * sizeof(int32_t));
        memcpy(copy, arr, N * sizeof(int32_t));

        printf("Before:\n");

        PrintArray(copy, N);

        printf("\nAfter:\n");

        QuickSort(copy, 0, N - 1);

        PrintArray(copy, N);

        bool isArraySorted = IsSorted(copy, N);

        printf("\nIsArraySorted: %s\n\n", isArraySorted ? "true" : "false");

        printf("---------------------\n\n");

        free(copy);
    }

    // Bogo Sort is separate as it's very unlikely to succeed on larger data.
    {
        printf("Sorting Algorithm: Bogo Sort\n\n");

        int n = 6;

        int32_t* smallArray = GenerateArray(n);

        PrintArray(smallArray, n);

        int iterations = BogoSort(smallArray, n);

        PrintArray(smallArray, n);

        bool isArraySorted = IsSorted(smallArray, n);

        printf("\n\nIsArraySorted: %s\n\n", isArraySorted ? "true" : "false");
        printf("Bogo Sort took: %i iterations\n\n", iterations);

        printf("---------------------\n\n");

        free(smallArray);
    }

    // Dictator Sort is separate as it has a return value (newly created array).
    {
        printf("Sorting Algorithm: Dictator Sort\n\n");

        int32_t* copy = malloc(N * sizeof(int32_t));
        memcpy(copy, arr, N * sizeof(int32_t));

        PrintArray(copy, N);

        int32_t* outputArray = DictatorSort(copy, N);

        int32_t size = PrintArrayOfUnspecifiedSize(outputArray);

        bool isArraySorted = IsSorted(outputArray, size - 1);

        printf("\n\nIsArraySorted: %s\n\n", isArraySorted ? "true" : "false");
        printf("Output array size: %i\n\n", size);

        printf("---------------------\n\n");

        free(copy);
        free(outputArray);
    }

    free(arr);
    
    return 0;
}

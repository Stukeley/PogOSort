#include <stdio.h>
#include <stdbool.h>
#include "../headers/DataGeneration.h"
#include "../headers/extern.h"
#include "../headers/PrintArray.h"
#include "../headers/IsSorted.h"

#define N 100
#define FCOUNT 5

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

    for (int i =0;i<FCOUNT;i++)
    {
        int32_t* copy = malloc(N * sizeof(int32_t));

        memcpy(copy, arr, N * sizeof(int32_t));

        PrintArray(copy, N);

        (*sorts[i]) (copy, N);

        PrintArray(copy, N);

        bool isArraySorted = IsSorted(copy, N);

        printf("\n\nIsArraySorted: %s\n\n", isArraySorted ? "true" : "false");
        
        free(copy);
    }

    // Bogo Sort is separate as it's very unlikely to succeed on larger data.
    {
        int n = 6;

        int32_t* smallArray = GenerateArray(n);

        PrintArray(smallArray, n);

        int iterations = BogoSort(smallArray, n);

        PrintArray(smallArray, n);

        bool isArraySorted = IsSorted(smallArray, n);

        printf("\n\nIsArraySorted (Bogo Sort): %s\n\n", isArraySorted ? "true" : "false");
        printf("Bogo Sort took: %i iterations\n\n", iterations);

        free(smallArray);
    }

    // Dictator Sort is separate as it has a return value
    {
        int32_t* copy = malloc(N * sizeof(int32_t));

        memcpy(copy, arr, N * sizeof(int32_t));

        PrintArray(copy, N);

        int32_t* outputArray = DictatorSort(copy, N);

        int32_t size = PrintArrayOfUnspecifiedSize(outputArray);

        bool isArraySorted = IsSorted(outputArray, size);

        printf("\n\nIsArraySorted (Dictator Sort): %s\n\n", isArraySorted ? "true" : "false");

        free(copy);
        free(outputArray);
    }

    free(arr);
    
    return 0;
}

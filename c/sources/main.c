#include <stdio.h>
#include <stdbool.h>
#include "../headers/DataGeneration.h"
#include "../headers/extern.h"
#include "../headers/PrintArray.h"
#include "../headers/IsSorted.h"

#define N 100
#define FCOUNT 3

int main() 
{
    int32_t* arr = GenerateArray(N);

    // https://stackoverflow.com/questions/252748/how-can-i-use-an-array-of-function-pointers
    void (*sorts[FCOUNT]) (int32_t * arr, int32_t n);

    sorts[0] = BubbleSort;
    sorts[1] = InsertionSort;
    sorts[2] = SelectionSort;

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

    free(arr);
    
    return 0;
}

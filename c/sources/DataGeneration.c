//
// Created by Rafał Klinowski on 30.05.2022.
//

#include "../headers/DataGeneration.h"

int32_t* GenerateArray(int32_t n)
{
    time_t t;
    srand((unsigned)time(&t));

    int32_t* arr = malloc(n * sizeof (int32_t));

    for (int i = 0; i < n; ++i)
    {
        arr[i] = (int32_t)(rand() % 100 + 1);
    }

    return arr;
}
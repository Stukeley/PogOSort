//
// Created by Rafał Klinowski on 30.05.2022.
//

#include "../headers/PrintArray.h"

void PrintArray(int32_t* arr, int32_t n)
{
    for (int i = 0; i < n; ++i) 
    {
        printf("[%i]: %i; ", i, arr[i]);
    }

    printf("\n");
}

int32_t PrintArrayOfUnspecifiedSize(int32_t* arr)
{
    int i = 0;

    while (arr[i] != 0)
    {
        printf("[%i]: %i; ", i, arr[i++]);
    }

    printf("\n");

    return i - 1;
}
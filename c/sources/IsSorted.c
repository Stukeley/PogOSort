#include "../headers/IsSorted.h"

bool IsSorted(int32_t* arr, int32_t n)
{
	for (int i = 0; i < n - 1; i++)
	{
		if (arr[i] > arr[i + 1])
		{
			return false;
		}
	}

	return true;
}
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int h;
    do
    {
        h = get_int("Height: ");
    }
    while (h >= 9 || h <= 0);

    for (int i = 1; i <= h; i++)
    {
        for (int n = 0; n < h; n++)
        {
            if (n < (h - i))
            {
                printf(" ");
            }
            else
            {
                printf("#");
            }
        }
        printf("  ");
        for (int b = h; b > 0; b--)
        {
            if (b > (h - i))
            {
                printf("#");
            }
        }
        printf("\n");
    }
}
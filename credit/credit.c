#include <cs50.h>
#include <stdio.h>
bool cardNumberLengthIsValid();
int calculateCheckSum();

int main(void)
{
    long card = get_long("Number: ");
    if (!cardNumberLengthIsValid(card))
    {
        printf("INVALID\n");
        return 0;
    }

    int sum = calculateCheckSum(card);
    printf("sum = %d\n", sum);

    if (sum % 10 != 0)
    {
        printf("INVALID\n");
        return 0;
    }

    long firstTwoDigits = card;
    while (firstTwoDigits >= 100)
    {
        firstTwoDigits /= 10;
    }

    if (firstTwoDigits == 34 || firstTwoDigits == 37)
    {
        printf("AMEX\n");
    }
    else if (firstTwoDigits > 50 && firstTwoDigits < 56)
    {
        printf("MASTERCARD\n");
    }
    else if (firstTwoDigits >= 40 && firstTwoDigits <= 49)
    {
        printf("VISA\n");
    }
    else
    {
        printf("INVALID\n");
    }
}

bool cardNumberLengthIsValid(long cardNumber)
{
    int count;
    for (count = 0; cardNumber != 0; count++)
    {
        cardNumber /= 10;
    }
    return 13 <= count && count <= 16;
}

int calculateCheckSum(long cardNumber)
{
    int sum = 0;
    for (int digit = 1; cardNumber != 0; digit++)
    {
        int last = cardNumber % 10;
        cardNumber /= 10;

        if (digit % 2 == 0)
        {
            int doublelast = last * 2;
            if (doublelast >= 10)
            {
                doublelast = doublelast % 10;
                doublelast += 1;
                sum += doublelast;
            }
            else
            {
                sum += doublelast;
            }
        }
        else
        {
            sum += last;
        }
    }
    return sum;
}
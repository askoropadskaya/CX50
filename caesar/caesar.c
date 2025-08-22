#include <cs50.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool only_digits(string str);
char rotate(char c, int n);
int main(int argc, string argv[])
{
    if (argc != 2 || only_digits(argv[1]) != true)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
    int key_number = atoi(argv[1]) % 26;

    string plaintext = get_string("plaintext:  ");

    for (int i = 0, len = strlen(plaintext); i < len; i++)
    {
        plaintext[i] = rotate(plaintext[i], key_number);
    }
    printf("ciphertext: %s\n", plaintext);
}

bool only_digits(string input)
{
    for (int i = 0; i < strlen(input); i++)
    {
        if (input[i] < 48 || input[i] > 57)
        {
            return false;
        }
    }
    return true;
}
char rotate(char c, int n)
{
    if (c >= 'A' && 'Z' >= c)
    {
        if (c + n > 'Z')
        {
            c = (c + n) - 26;
        }
        else
        {
            c += n;
        }
    }
    else if (c >= 'a' && 'z' >= c)
    {
        if (c + n > 'z')
        {
            c = (c + n) - 26;
        }
        else
        {
            c += n;
        }
    }
    return c;
}
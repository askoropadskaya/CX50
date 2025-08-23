#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

// Points assigned to each letter of the alphabet
int POINTS[] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};

int compute_score(string word);
string lowercase_word(string word);

int main(void)
{
    // Get input words from both players
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    // Lowercase the words
    word1 = lowercase_word(word1);
    word2 = lowercase_word(word2);

    // Score both words
    int score1 = compute_score(word1);
    int score2 = compute_score(word2);

    // TODO: Print the winner
    if (score1 > score2)
    {
        printf("Player 1 wins!\n");
    }
    else if (score1 < score2)
    {
        printf("Player 2 wins!\n");
    }
    else
        printf("Tie!\n");
}

int compute_score(string word)
{
    int score = 0;

    for (int i = 0, len = strlen(word); i < len; i++)
    {
        if (islower(word[i]))
        {
            int index = (int) word[i] - (int) 'a';
            score += POINTS[index];
        }
    }
    return score;
}

string lowercase_word(string word)
{
    for (int i = 0, len = strlen(word); i < len; i++)
    {
        word[i] = tolower(word[i]);
    }
    return word;
}

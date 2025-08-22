#include "helpers.h"
#include <math.h>
#include <stdlib.h>

RGBTRIPLE blurredPixel(int height, int width, RGBTRIPLE image[height][width], int h, int w);
RGBTRIPLE edgedPixel(int height, int width, RGBTRIPLE image[height][width], int h, int w);
// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            float avg = (image[h][w].rgbtBlue + image[h][w].rgbtRed + image[h][w].rgbtGreen) / 3.0;
            int gray = round(avg);
            image[h][w].rgbtBlue = gray;
            image[h][w].rgbtRed = gray;
            image[h][w].rgbtGreen = gray;
        }
    }
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width / 2; w++)
        {
            RGBTRIPLE temp_pixel = image[h][w];
            image[h][w] = image[h][width - 1 - w];
            image[h][width - 1 - w] = temp_pixel;
        }
    }
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE(*blurred_image)[width] = calloc(height, width * sizeof(RGBTRIPLE));

    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            blurred_image[h][w] = blurredPixel(height, width, image, h, w);
        }
    }

    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            image[h][w] = blurred_image[h][w];
        }
    }
    free(blurred_image);
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE(*edged_image)[width] = calloc(height, width * sizeof(RGBTRIPLE));

    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            edged_image[h][w] = edgedPixel(height, width, image, h, w);
        }
    }

    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            image[h][w] = edged_image[h][w];
        }
    }
    free(edged_image);
}

RGBTRIPLE blurredPixel(int height, int width, RGBTRIPLE image[height][width], int h, int w)
{
    int counter = 0;
    int green = 0;
    int blue = 0;
    int red = 0;

    for (int y = h - 1; y <= h + 1; y++)
    {
        for (int x = w - 1; x <= w + 1; x++)
        {
            if (y < height && y >= 0 && x < width && x >= 0)
            {
                green += image[y][x].rgbtGreen;
                red += image[y][x].rgbtRed;
                blue += image[y][x].rgbtBlue;
                counter++;
            }
        }
    }
    RGBTRIPLE pixel;
    pixel.rgbtGreen = round(green / (float) counter);
    pixel.rgbtRed = round(red / (float) counter);
    pixel.rgbtBlue = round(blue / (float) counter);
    return pixel;
}

RGBTRIPLE edgedPixel(int height, int width, RGBTRIPLE image[height][width], int h, int w)
{
    float green = 0;
    float blue = 0;
    float red = 0;

    int gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int gy[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

    RGBTRIPLE pixels[3][3];
    int rgx = 0;
    int bgx = 0;
    int ggx = 0;

    int rgy = 0;
    int bgy = 0;
    int ggy = 0;

    for (int y = h - 1; y <= h + 1; y++)
    {
        for (int x = w - 1; x <= w + 1; x++)
        {
            int px = x - (w - 1);
            int py = y - (h - 1);
            if (y < height && y >= 0 && x < width && x >= 0)
            {
                pixels[py][px] = image[y][x];
            }
            else
            {
                pixels[py][px].rgbtRed = 0;
                pixels[py][px].rgbtBlue = 0;
                pixels[py][px].rgbtGreen = 0;
            }
        }
    }

    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            rgx += gx[i][j] * pixels[j][i].rgbtRed; // multiply pixels by Gx
            bgx += gx[i][j] * pixels[j][i].rgbtBlue;
            ggx += gx[i][j] * pixels[j][i].rgbtGreen;

            rgy += gy[i][j] * pixels[j][i].rgbtRed; // multiply pixels by Gy
            bgy += gy[i][j] * pixels[j][i].rgbtBlue;
            ggy += gy[i][j] * pixels[j][i].rgbtGreen;
        }
    }

    red = sqrt(rgx * rgx + rgy * rgy);
    if (red > 255)
    {
        red = 255;
    }

    blue = sqrt(bgx * bgx + bgy * bgy);
    if (blue > 255)
    {
        blue = 255;
    }

    green = sqrt(ggx * ggx + ggy * ggy);
    if (green > 255)
    {
        green = 255;
    }

    RGBTRIPLE result;
    result.rgbtRed = round(red);
    result.rgbtBlue = round(blue);
    result.rgbtGreen = round(green);

    return result;
}
/*
 *
 * Author: jseg380
 * File: ~/.local/bin/c_program/get_direction.c
 * 
 * Instructions:
 * Compile with gcc -o get_direction get_direction.c
 *
 * */
#include <stdio.h>
#include <string.h>

#define false 0
#define true 1

const char * up[] = {"up", "u", "north", "n"};
const char * right[] = {"right", "r", "east", "e"};
const char * down[] = {"down", "d", "south", "s"};
const char * left[] = {"left", "l", "west", "w"};
const int ERROR_CODE = 10;

// Apparently bool doesn't exist in C, its necessary to #include <stdbool.h>
//bool in(const char * word, const char * array[], int n);

int in(const char * word, const char * array[], int n);

int main(int argc, char * argv[]) {
    
  if (argc != 2)
    return ERROR_CODE;

  if (in(argv[1], up, 4))
    return 0;
  else if (in(argv[1], right, 4))
    return 1;
  else if (in(argv[1], down, 4))
    return 2;
  else if (in(argv[1], left, 4))
    return 3;
    
  return ERROR_CODE;
}


int in(const char * word, const char * array[], int n) {
  int in = false;
  
  for (int i = 0; i < n && in == false; i++)
    if (strcmp(word, array[i]) == 0)
      in = true;
  
  return in;
}

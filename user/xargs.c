#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

// Function to reset elements of the argument array to 0 starting from 'start' index
void clear(char *xargv[MAXARG], int start){
  for(int i = start; i < MAXARG; i++){
    xargv[i] = 0; 
  }
}

int main(int argc, char *argv[])
{
  if(argc < 2){
    fprintf(2, "Usage: xarg <cmd>\n"); 
    exit(1);
  }
  
  // Check if the arguments exceed the maximum allowed number
  if(argc > MAXARG){
    fprintf(2, "xargs: too many arguments\n"); 
    exit(1);
  }

  char *xargv[MAXARG] = {0}; 
  int xargc = 0;

  // Copy initial arguments from the command line into the argument array
  for(; xargc + 1 < argc; xargc++){
    xargv[xargc] = argv[xargc + 1]; 
  }

  char buf[1024]; 
  char c;         
  int p = 0;     
  int start = 0;  

  // Read input character by character from stdin
  while(read(0, &c, 1)){
    
    // Handle spaces, newlines, and other characters
    if(c == ' '){  // If the character is a space, mark the end of the word
      buf[p] = 0; 
      xargv[xargc++] = &buf[start]; 
      start = p;  
    }
    else if(c == '\n'){  // If the character is a newline, execute the command
      buf[p] = 0; 
      xargv[xargc++] = &buf[start]; 

      if(fork() == 0){
        exec(argv[1], xargv); 
      } else {
        wait(0); 
      }

      // Reset the argument count and clear the argument array for the next input
      xargc = argc - 1;
      clear(xargv, xargc); 
      p = 0;  
      start = 0; 
    }
    else {  // If it's any other character, add it to the buffer
      buf[p++] = c; 
    }
  }
  
  exit(0); 
}


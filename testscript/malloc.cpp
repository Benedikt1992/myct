#include <iostream>
#include <stdlib.h>     /* malloc, free, rand */

int main ()
{
  int mbs = 100;
  uint16_t j = 1;
  while(1 == 1) {
    uint8_t* buffer;
    buffer = (uint8_t*) malloc (1024 * 1024 * mbs);
    if (buffer==NULL) exit (1);
    for(int i=0; i < 1024 * 1024 * mbs; i+=1024) {
      buffer[i] = 150;
    }
    printf("Successfully allocated %d MB of memory.\n", mbs*(j++));
  }
  return 0;
}

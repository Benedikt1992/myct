#include <iostream>
#include <stdlib.h>     /* malloc, free, rand */

int main ()
{
  uint8_t* buffer;
  buffer = (uint8_t*) malloc (1024 * 1024 * 50);
  if (buffer==NULL) exit (1);

  printf("Successfully allocated 50 MB of memory.\n");
  free (buffer);
  return 0;
}

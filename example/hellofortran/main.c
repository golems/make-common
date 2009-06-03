
#include "hellofortranexample.h"
#include <stdio.h>

void mat_print(double *a, int rows, int cols);


#define FINDEX1(array, i) ((array)[(i)-1])
#define FINDEX2(array, rows, i,j) ((array)[ ((j)-1)*rows + ((i)-1) ] )
#define ROWS 3
#define COLS 2



int main( int argc, char **argv) {
    {
        // some fortran
        printf("Hello fortran:\n");
        double array[] = {1, 2, 3, 4};
        int n = sizeof(array)/sizeof(double);
        hello_fortran_( array, &n );
    }



    // some more practical fortran
    {
        printf("Some Fortran Math\n");
        double matrix[COLS][ROWS] = { {1, 3, 5}, {2, 4, 6} };
        double vector[ROWS] = {7, 8, 9};
        double res[COLS];

        int rows = ROWS, cols = COLS;

        printf(" Matrix\n");
        mat_print( &matrix[0][0], rows, cols );

        printf(" Vector\n");
        mat_print( &vector[0], 1, rows );

        better_fortran_(&matrix[0][0], &vector[0], &res[0], &rows, &cols);
        printf(" (matrix' * vector) + 2\n");
        mat_print( &res[0], 1, cols );
    }


}

void mat_print(double *a, int rows, int cols) {
  int i, j;
  for( i = 1; i <= rows; i++ ) {
      printf("  ");
      for(j = 1; j<=cols; j++ ) {
          printf ("%f  ", FINDEX2(a, rows, i, j) );
      }
      printf("\n");
  }
}


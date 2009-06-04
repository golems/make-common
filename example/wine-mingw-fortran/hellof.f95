MODULE hello_helper
CONTAINS
END MODULE hello_helper

SUBROUTINE hello_fortran( array, n )
    integer :: n
    real(8), dimension(n) :: array
    print *, "[fortran] n: ", n
    print *, "[fortran] Array: ", array
END SUBROUTINE hello_fortran


SUBROUTINE better_fortran( matrix, array, res, rows, cols )
    integer :: rows, cols
    real(8), dimension(rows,cols) :: matrix
    real(8), dimension(rows) :: array
    real(8), dimension(cols) :: res
    print *, "[fortran] matrix: ", matrix
    print *, "[fortran] array: ", array
    res = matmul( transpose(matrix), array) + 2
    print *, "[fortran] Result: ", res
END SUBROUTINE better_fortran


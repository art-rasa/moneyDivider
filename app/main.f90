! 
! name: moneyDivider
! 
! Program that attempts to divide a sum of money as fairly as possible
! between given number of people while avoiding round-off error.
! 
! Draws inspiration from: https://www.hildeberto.com/2020/04/dealing-with-money.html
! 
program main
    implicit none
    
    integer, parameter :: MAX_LEN = 20
    character (len=MAX_LEN) :: user_input
    integer :: num_people
    integer :: money
    integer, dimension(:), allocatable :: divisions
    
    write(unit=*, fmt='(a)', advance='no') 'Enter amount of money: '
    read *, user_input
    
    write(unit=*, fmt='(a)', advance='no') 'Enter number of people: '
    read *, num_people
    
    if (num_people < 1) then
        print '(a)', 'Error: invalid number of people.'
        stop 1
    end if
    
    allocate(divisions(1:num_people))
    
    if (dec_to_int(user_input, money)) then
        print '(a)', 'Error: Overflow or invalid input.'
        stop 1
    end if
    
    call divide_money(money, divisions)
    call print_shares(divisions)

    deallocate(divisions)
contains

    ! Divides "total" amount of money into "shares" as fairly as 
    ! possible.
    subroutine divide_money(total, shares)
        integer, intent(in) :: total
        integer, dimension(:), allocatable, intent(inout) :: shares
        integer :: div
        integer :: rem
        integer :: i
        integer :: j
        
        div = total / size(shares)
        rem = total - (div * size(shares))
        
        do i = 1, size(shares)
            shares(i) = div
        end do
        
        j = 1
        do i = rem, 1, -1
            shares(j) = shares(j) + 1
            j = j + 1
        end do
    end subroutine
    
    
    ! Prints the shares for each person.
    subroutine print_shares(shares)
        integer, dimension(:), allocatable, intent(in) :: shares
        integer :: sum_money
        integer :: i
        
        print '(a)', repeat('-', 50)
        
        sum_money = 0
        do i = 1, size(shares)
            write(*, '(4x,a,i0,a,f0.2)') 'person #', i, ' receives: ', & 
                real(shares(i))/100.0
            
            sum_money = sum_money + shares(i)
        end do
        
        print '(a)', repeat('-', 50)
        print '(a,f0.2)', 'Total: ', real(sum_money)/100.0
    end subroutine
    
    
    ! Converts a string containing a non-negative decimal number into 
    ! an integer. Result is placed into "int_value".
    ! Returns an error flag.
    ! Example: dec_to_int('1234.56', int_var) 123456--->int_var
    function dec_to_int(str, int_value) result (is_error)
        character (len=*), intent(in) :: str
        integer, intent(out) :: int_value
        integer :: dot_pos
        integer :: whole_part
        integer :: decimal_part
        character (len=*), parameter :: fmt_str = '(i10)'
        logical :: is_error
        integer :: end_pos
        
        is_error = .false.
        
        dot_pos = index(str, '.')
        
        if (dot_pos == 0) then
            read(str, fmt_str) whole_part
            whole_part = whole_part * 100
            decimal_part = 0
        else
            read(str(1:dot_pos-1), fmt_str) whole_part
            whole_part = whole_part * 100
            end_pos = min(dot_pos + 2,len_trim(str))
            read(str(dot_pos + 1:end_pos), fmt_str) decimal_part
        end if
        
        ! Integer overflow, result is invalid.
        if (whole_part < 0) then
            is_error = .true.
        end if
        
        int_value = whole_part + decimal_part
    end function
    
end program main
















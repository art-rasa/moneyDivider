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
    
    localize: block 
    
    integer, parameter :: MAX_LEN = 20
    character (len=MAX_LEN) :: user_input
    integer :: num_people
    integer :: money
    integer, dimension(:), allocatable :: divisions
    integer :: beginner
    
    write(unit=*, fmt='(a)', advance='no') 'Enter amount of money: '
    read *, user_input
    
    if (dec_to_int(user_input, money)) then
        stop 'Error: Overflow or invalid input.'
    end if
    
    if (money <= 0) then
        stop 'Error: Invalid amount of money.'
    end if
    
    write(unit=*, fmt='(a)', advance='no') 'Enter number of people: '
    read *, num_people
    
    if (num_people < 1) then
        stop 'Error: invalid number of people.'
    end if
    
    call line()
    
    call choose_beginner(beginner, num_people)
    
    allocate(divisions(1:num_people))
    
    call divide_money(money, divisions, beginner)
    call print_shares(divisions)

    deallocate(divisions)
    
    end block localize
contains

    ! Prints a line.
    subroutine line()
        print '(a)', repeat('-', 50)
    end subroutine

    ! Choose a random person who gets the remainder first.
    subroutine choose_beginner(beginner, max_num)
        integer, intent(out) :: beginner
        integer, intent(in) :: max_num
        real :: rn, rn_scaled
        call random_number(rn)
        rn_scaled = (rn * max_num) + 1.0
        beginner = floor(rn_scaled)
    end subroutine

    ! Divide "total" amount of money into "shares" as fairly as 
    ! possible.
    subroutine divide_money(total, shares, starter)
        integer, intent(in) :: total
        integer, dimension(:), allocatable, intent(inout) :: shares
        integer, intent(in) :: starter
        integer :: div, rem, i, j
        
        div = total / size(shares)
        rem = total - (div * size(shares))
        
!~         do i = 1, size(shares)
!~             shares(i) = div
!~         end do
        shares  = div
        
        write(*, fmt=140) 'Individual share per person:', div/100.0
        if (rem /= 0) then
            write(*, fmt='(4x,a)', advance='no') 'Remainder:'
            if (rem < 100) then
                write(*, fmt='(x,a)', advance='no') '0'
            end if
            write(*, fmt='(f0.2)') rem/100.0
            write(*, fmt='(4x,a)', advance='no') &
                    'Distributing remainder to'
            if (rem == 1) then
                write(*, fmt='(x,a)', advance='no') 'person:'
            else
                write(*, fmt='(x,a)', advance='no') 'persons:'
            end if
        end if
        
        j = starter
        do i = rem, 1, -1
            write(*, fmt='(x,a,i0)', advance='no') '#', j
            shares(j) = shares(j) + 1
            j = j + 1
            if (j > size(shares)) then
                j = 1
            end if
        end do
        
        if (rem /= 0) then
            write(*, '(a)') '.' // new_line('a')
        end if
        
        140 format (4x,a,x,f0.2)
    end subroutine
    
    
    ! Prints the shares for each person.
    subroutine print_shares(shares)
        integer, dimension(:), allocatable, intent(in) :: shares
        integer :: sum_money
        integer :: i
        
        sum_money = 0
        do i = 1, size(shares)
            write(*, fmt=150) 'person #', i, ' receives: ', & 
                real(shares(i))/100.0
            
            sum_money = sum_money + shares(i)
        end do
        
        call line()
        write(*, fmt=160), 'Total: ', real(sum_money)/100.0
        150 format (4x,a,i0,a,f0.2)
        160 format (4x,a,f0.2)
        
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
















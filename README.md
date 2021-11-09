# moneyDivider

## Description

MoneyDivider is a Fortran program that attempts to divide a sum of money as fairly as possible between given number of people while avoiding round-off error.

It draws inspiration from this article: https://www.hildeberto.com/2020/04/dealing-with-money.html

## Example

```
$ fpm run
Enter amount of money: 151.99
Enter number of people: 3
--------------------------------------------------
    person #1 receives: 50.67
    person #2 receives: 50.66
    person #3 receives: 50.66
--------------------------------------------------
Total: 151.99
```

## Installation

This program was compiled with [GFortran](https://gcc.gnu.org/fortran/) and packaged with [FPM, the Fortran Package Manager](https://github.com/fortran-lang/fpm).


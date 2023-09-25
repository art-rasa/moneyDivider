# moneyDivider

## Description

MoneyDivider is a Fortran program that attempts to divide a sum of money as fairly as possible between given number of people while avoiding round-off error.

It draws inspiration from this article: https://www.hildeberto.com/2020/04/dealing-with-money.html

## Example run

```
$ fpm run
Project is up to date
Enter amount of money: 1501.63
Enter number of people: 7
--------------------------------------------------
    Individual share per person: 214.51
    Remainder: 0.06
    Distributing remainder to persons: #7 #1 #2 #3 #4 #5.

    person #1 receives: 214.52
    person #2 receives: 214.52
    person #3 receives: 214.52
    person #4 receives: 214.52
    person #5 receives: 214.52
    person #6 receives: 214.51
    person #7 receives: 214.52
--------------------------------------------------
    Total: 1501.63
```

## Building and running

* Install [FPM](https://github.com/fortran-lang/fpm) (Fortran Package
  Manager) and copy it into your $PATH as `fpm`.
* Clone the git repository.
* Execute the command `fpm run` inside the base directory of the 
  repository. 

This program was compiled with [GFortran](https://gcc.gnu.org/fortran/) and packaged with [FPM, the Fortran Package Manager](https://github.com/fortran-lang/fpm).


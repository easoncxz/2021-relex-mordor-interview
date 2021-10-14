This is the interview scaffold for the Mordor team at RELEX Oy.

We have tried to incorporate all the main ways of using Haskell, cabal, stack
and nix.

The interviewee should receive a link to this repository together with the
problem statement.

## Using Nix

``` console
$ nix-shell --run $SHELL
$ cabal build
```

## Using Cabal

``` console
$ cabal build
```

## Using stack

``` console
$ stack build
```

## Rules

- Don't remove/disable the tests
- Follow the problem statement
- Pretty much everything else is up to the interviewer, refactor code, modify cabal, add tests etc.

# Symbol recognition

Neural Networks first experiments by Sergey Vasilyev. July 1997.

The symbols are drawn as kind of graphics with bits on/off — but in a text file (see `alphabet`, `table`, `symbols` files):

```
----------A
----11111-
---1----1-
--1-----1-
-1------1-
-1------1-
-11111111-
-1------1-
-1------1-
----------
----------B
-111111---
-1-----1--
-1-----1--
-1111111--
-1------1-
-1------1-
-1------1-
-1111111--
----------
----------C
--111111--
-1------1-
-1--------
-1--------
-1--------
-1--------
-1------1-
--111111--
----------
```

Similarly, unexistent chimera symbols can be asked for recognition:

```
----------?
-1111111--
-1------1-
-1------1-
-1------1-
-1111111--
-1--------
-1--------
-111111--
----------
```

The neural network architecture is a 2-layer network. 

There are multiple (1..20) neural networks (aka "sentators")
voting on the resulting symbols with its own certainty. 
The senators are trained sequentially and independently of each other, 
with random weights in the beginning each.


## Build

On Mac OS X, Free Pascal is needed:

```
brew install fpc
```

Then build:

```
fpc -Mtp -WM10.9 senate.pas
```

Check that it works (these are Russian letters):

```
$ ./senate
СимволоРаспознаватель (C) 1997 Васильев Сергей
Запуск: SENATE.EXE <учебник> <вопросник> [<файл отчета> [<кол-во сенаторов>]]
```

Translated as:

```
SymbolRecogniser (c) 1997 Sergey Vasilyev
To run: SENATE.EXE <trainbook> <questionbook> [<report file> [<number of senators>]]
```

## Run

For a simple A-B-C reconition, use `table` as a trainbook:

```
./senate table symbols report.txt 20
```

See the tail of `report.txt` for output:

```
========================================
ИТОГО:
1й символ есть "A": 80%
2й символ есть "C": 70%
3й символ есть "C": 45%
4й символ есть "C": 70%
----------------------------------------
Сенатор #1 был прав
Сенатор #8 был прав
Сенатор #15 был прав
Сенатор #18 был прав
```

Translated as:

```
========================================
RESULTS:
1st symbol is "A": 80%
2nd symbol is "C": 70%
3rd symbol is "C": 45%
4th symbol is "C": 70%
----------------------------------------
Senator #1 was right
Senator #8 was right
Senator #15 was right
Senator #18 was right
```

The percentages are number of "senators" voted for each result for each symbol.
Which is a close equivalent of the certainty of the whole "senate".
The centainty of 45% means all 20 of them are quite unsure and cannot decide,
while 80% is highly likely a sure thing.

Here is the output of when the trainbook is given as a questionbook (translated):

```
$ ./senate table table report2.txt 20
```

```
========================================
RESULTS:
1st symbol is "A":100%
2nd symbol is "C": 50%
3rd symbol is "C": 85%
----------------------------------------
Senator #1 was right
Senator #2 was right
Senator #5 was right
Senator #11 was right
Senator #12 was right
Senator #15 was right
Senator #17 was right
Senator #18 was right
Senator #19 was right
Senator #20 was right
```

*(Even in that case they have failed with the letter "B".)*


You can try running with full `alphabet` as a trainbook, but it will take forever,
and requires tuning the NN parameters:

```
  hConst        =0.2       ;{~(0..1)  lower is smart, but slow; higher is dumb, but fast}
```

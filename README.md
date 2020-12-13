# Program-Finder-from-Data-
Finds recursive algorithms from the structure of data.

# Getting Started

Please read the following instructions on how to install the project on your computer for writing algorithms.

# Prerequisites

Please download and install SWI-Prolog for your machine at https://www.swi-prolog.org/build/.

Please download Lucian Green's List Prolog Interpreter Repository at https://github.com/luciangreen/listprologinterpreter.


# Installation from List Prolog Package Manager (LPPM)

* Optionally, you can install from LPPM by installing <a href="https://www.swi-prolog.org/build/">SWI-Prolog</a> for your machine, downloading the <a href="https://github.com/luciangreen/List-Prolog-Package-Manager">LPPM Repository</a>,
```
git clone https://github.com/luciangreen/List-Prolog-Package-Manager.git
cd List-Prolog-Package-Manager
swipl
```
loading LPPM with `['lppm'].` then installing the package by running `lppm_install("luciangreen","Program-Finder-from-Data-").`.

# Installing

* Download the repository to your machine.
In the SWI-Prolog environment, enter the following to load the algorithm:
`['programfinder'].`

* Running the algorithm
To generate an algorithm:
`Input1=[["n","a"]],Inputs2=[["a",5]] ,Output=[["n", 5]] ,programfinder(Input1,Inputs2,Output,Extras,Program),writeln(Program),interpret(on,[[n,function],[Input1,Inputs2,[],[v,result]]],Program,Result).`    

# Versioning

We will use SemVer for versioning.

# Authors

Lucian Green - Initial programmer - <a href="https://www.lucianacademy.com/">Lucian Academy</a>

# License

I licensed this project under the BSD3 License - see the LICENSE.md file for details

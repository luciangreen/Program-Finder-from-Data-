# Program-Finder-from-Data-
Finds recursive algorithms from the structure of data.

# Getting Started

Please read the following instructions on how to install the project on your computer for writing algorithms.

# Prerequisites

Please download and install SWI-Prolog for your machine at https://www.swi-prolog.org/build/.

(For later commits) please download Lucian Green's List Prolog Interpreter Repository at https://github.com/luciangreen/listprologinterpreter.

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

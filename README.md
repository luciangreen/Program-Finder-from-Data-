# Program-Finder-from-Data-
Finds recursive algorithms from the structure of data.

# Getting Started

Please read the following instructions on how to install the project on your computer for writing algorithms.

# Prerequisites

* Please download and install SWI-Prolog for your machine at `https://www.swi-prolog.org/build/`.

# 1. Install manually

Download <a href="http://github.com/luciangreen/Program-Finder-from-Data-/">this repository</a>, the <a href="https://github.com/luciangreen/listprologinterpreter">List Prolog Interpreter Repository</a>.

# 2. Or Install from List Prolog Package Manager (LPPM)

* Download the <a href="https://github.com/luciangreen/List-Prolog-Package-Manager">LPPM Repository</a>:

```
git clone https://github.com/luciangreen/List-Prolog-Package-Manager.git
cd List-Prolog-Package-Manager
swipl
['lppm'].
lppm_install("luciangreen","Program-Finder-from-Data-")
halt
```

# Running

* In Shell:
`cd Program-Finder-from-Data-`
`swipl`
`['programfinder'].`

* Running the algorithm
To generate an algorithm:
`Input1=[["n","a"]],Inputs2=[["a",5]] ,Output=[["n", 5]] ,programfinder(Input1,Inputs2,Output,Extras,Program),writeln1(Program),international_interpret([lang,"en"],on,[[n,function],[Input1,Inputs2,[],[v,result]]],Program,Result).`    

# Versioning

We will use SemVer for versioning.

# Authors

Lucian Green - Initial programmer - <a href="https://www.lucianacademy.com/">Lucian Academy</a>

# License

I licensed this project under the BSD3 License - see the LICENSE.md file for details

%% Program Finder

/**

Also load interpret.

*** BEFORE
?- Input1=[[n,a]],Inputs2=[[a,5]] ,Output=[[n, 5]] ,programfinder(Input1,Inputs2,Output,Extras,Program),writeln(Program),interpret(off,[function,[Input1,Inputs2,[],result]],Program,Result).
[[function,[[],inputs2,output,output]],[function,[input1,inputs2,inputs3,output],:-,[[head,input1,head],[tail,input1,tail],[head=[a,b]],[[atom,a],[atom,b]],[member,inputs21,inputs2],[inputs21=[b,c]],[item1=[a,c]],[append,inputs3,item1,item2],[function,[tail,inputs2,item2,output]]]]]
Input1 = [[n, a]],
Inputs2 = [[a, 5]],
Output = [[n, 5]],
Extras = [],
Program = [[function,[[],inputs2,output,output]],[function,[input1,inputs2,inputs3,output],:-,[[head,input1,head],[tail,input1,tail],[head=[a,b]],[[atom,a],[atom,b]],[member,inputs21,inputs2],[inputs21=[b,c]],[item1=[a,c]],[append,inputs3,item1,item2],[function,[tail,inputs2,item2,output]]]]],
Result = [[result, [n, 5]]] 

** AFTER

Input1=[[n,a]],Inputs2=[[a,5]] ,Output=[[n, 5]] ,programfinder(Input1,Inputs2,Output,Extras,Program),writeln(Program),interpret(off,[[n,function],[Input1,Inputs2,[],[v,result]]],Program,Result).
[[[n,function],[[],[v,inputs2],[v,output],[v,output]]],[[n,function],[[v,input1],[v,inputs2],[v,inputs3],[v,output]],:-,[[[n,head],[[v,input1],[v,head]]],[[n,tail],[[v,input1],[v,tail]]],[[n,=],[[v,head],[[v,a],[v,b]]]],[[[n,atom],[v,a]],[[n,atom],[v,b]]],[[n,member],[[v,inputs21],[v,inputs2]]],[[n,=],[[v,inputs21],[[v,b],[v,c]]]],[[[n,number],[v,c]]],[[n,=],[[v,item1],[[v,a],[v,c]]]],[[n,append],[[v,inputs3],[v,item1],[v,item2]]],[[n,function],[[v,tail],[v,inputs2],[v,item2],[v,output]]]]]]
Input1 = [[n, a]],
Inputs2 = [[a, 5]],
Output = [[n, 5]],
Extras = Result, Result = [],

**/

programfinder(Input1,Inputs2,Output,Extras,Program) :-
	labelall(Inputs2,inputs2,1,1,[],Inputs2Labels),
%%writeln([inputs2Labels,Inputs2Labels]),
	label(Extras,extras,1,1,[],ExtrasLabels),
%%writeln([extrasLabels,ExtrasLabels]),
%%	Inputs2=[Item|_Items],
%%	((length(Item,1),Extra=[])-> %% () is2 has 1-length tuples - then processes i1, is2 simultaneously
%%	replace1is2(Input1,Inputs2,Output,Program);
	replace(Input1,Output,Inputs2Labels,ExtrasLabels,[],Relations1), %% replace returns the relations for given input for a replacement
%%writeln([relations1,Relations1]),
        deleteduplicates(Relations1,[],Relations2),
%%writeln([relations2,Relations2]),
	FunctionName=[n,function],
	(not(member([extrarelation,_,_,_,_,_],Relations2))->
	makebasecase(FunctionName,BaseCase);
        makebasecase2(FunctionName,BaseCase)),
%%writeln([baseCase,BaseCase]),
	findprogram(FunctionName,Relations2,1,[],Program1),
	append(BaseCase,Program1,Program)
	.
%%)
/**
replace1is2(Input1,Inputs2,Output,Program) :-
	Input1=[Item1|Items1],
	Inputs2=[Item2|Items2],
        Output=[Item3|Items3],
**/
replace([],_Output1,_Inputs2Labels,_ExtrasLabels,Relations,Relations).
replace(Input1,Output1,Inputs2Labels,ExtrasLabels,Relations1,Relations2) :-
	((atom(Input1);number(Input1))->Input1a=[Input1];Input1a=Input1),
	Input1a=[Item1|Items1],
        ((atom(Output1);number(Output1))->Output1a=[Output1];Output1a=Output1),
	Output1a=[Item2|Items2], %% record what we need to give to output, then give it in a clause acc considerations
	label(Item1,input1,1,1,[],Input1Labels),
	label(Item2,output,1,1,[],OutputLabels), %% find position, type of values, (will find identicalness)
	relations1(Input1Labels,OutputLabels,Inputs2Labels,ExtrasLabels,Relations1,Relations3), %% find rel types, which case extra/findargs relates to
%% ExtrasLabels later
%% return option config from rep, type config in extras, extras with relations
	replace(Items1,Items2,Inputs2Labels,ExtrasLabels,Relations3,Relations2).
	
labelall([],_Range,_ListItemNumber,_Position,Labels,Labels).
labelall(Data1,Range,ListItemNumber,Position1,Labels1,Labels2) :-
	Data1=[Data2|Data3],
	label(Data2,Range,ListItemNumber,Position1,Labels1,Labels3),
	Position2 is Position1 + 1,
	labelall(Data3,Range,ListItemNumber,Position2,Labels3,Labels2).
label([],_Range,_ItemNumber,_Position,ItemLabels,ItemLabels).
label(Item1,Range,ItemNumber,Position1,ItemLabels1,ItemLabels2) :-
	((atom(Item1);number(Item1))->Item1a=[Item1];Item1a=Item1),
	Item1a=[Item2|Items], %% removed [] from i1
	((atom(Item2),Type=[n,atom]);
	(number(Item2),Type=[n,number]);
	(string(Item2),Type=[n,string]);
	(var(Item2),Type=[n,variable])), %% ***
	Label=[Item2,Type,Range,ItemNumber,Position1],
	append(ItemLabels1,[Label],ItemLabels3),
	Position2 is Position1 + 1,
	label(Items,Range,ItemNumber,Position2,ItemLabels3,ItemLabels2).
relations1([],_OutputLabels,_Inputs2Labels,_ExtrasLabels,Relations,Relations).
relations1(Input1Labels,OutputLabels,Inputs2Labels,ExtrasLabels,Relations1,Relations2) :-
        ((atom(Input1Labels);number(Input1Labels))->Input1Labels1a=[Input1Labels];Input1Labels1a=Input1Labels),
	Input1Labels1a=[Item1a|Items1],
	Item1a=[Item1,Type1,Range1,ItemNumber1,Position1],
	relations2(Item1,Type1,Range1,ItemNumber1,Position1,_Items1,OutputLabels,Inputs2Labels,ExtrasLabels,Relations1,Relations3),
	relations1(Items1,OutputLabels,Inputs2Labels,ExtrasLabels,Relations3,Relations2).
/**relations2(Item1,Range1,ItemNumber1,Position1,Items1,_OutputLabels,_Inputs2Labels,_ExtrasLabels,Relations1,Relations2,ExtrasRelations,ExtrasRelations) :-
writeln(r21),
	member(Item2a,Items1),
	Item2a=[Item2,_Type2,Range2,ItemNumber2,Position2],
	Item1=Item2,
	append(Relations1,[[Item1,Range1,ItemNumber1,Position1],[Item2,Range2,ItemNumber2,Position2]],Relations2).
**/
relations2(Item1,Type1,Range1,ItemNumber1,Position1,_Items1,OutputLabels,Inputs2Labels,ExtrasLabels,Relations1,Relations2) :-
%%writeln(r22),
	((Option1=Inputs2Labels,Option2=OutputLabels);(Option1=OutputLabels,Option2=Inputs2Labels)),
        member(Item2a,Option1),
        Item2a=[Item2,Type2,Range2,ItemNumber2,Position2],
        Item1=Item2,
        append(Relations1,[[[Item1,Type1,Range1,ItemNumber1,Position1],[Item2,Type2,Range2,ItemNumber2,Position2]]],Relations3),
        member(Item3a,Option1),
        Item3a=[Item3,Type3,Range3,ItemNumber3,Position3],
	ItemNumber2=ItemNumber3,
	((Item3=empty,Position1=Position2,not(Position2=Position3))->(
        member(Item5a,ExtrasLabels),
	Item5a=[Item5,Type5,Range5,ItemNumber5,Position5],
        Item2=Item5,
	append(Relations3,[[extrarelation,Item5,Type5,Range5,ItemNumber5,Position5]],Relations4)
	);Relations4=Relations3),(	
        member(Item4a,Option2),
        Item4a=[Item4,Type4,Range4,ItemNumber4,Position4],
        Item3=Item4,
        append(Relations4,[[[Item3,Type3,Range3,ItemNumber3,Position3],[Item4,Type4,Range4,ItemNumber4,Position4]]],Relations2)),
	!.
relations2(Item1,_Range1,_ItemNumber1,_Position1,_Items1,OutputLabels,Inputs2Labels,ExtrasLabels,Relations1,Relations2) :-
writeln(r23),
%%	((Item3=empty,Position1=Position2,not(Position2=Position3))->(
        member(Item5a,ExtrasLabels),
        Item5a=[Item5,Type5,Range5,ItemNumber5,Position5],
        Item1=Item5,
        append(Relations1,[[extrarelation,Item5,Type5,Range5,ItemNumber5,Position5]],Relations2),
        %%);ExtrasRelations1=ExtrasRelations2),
	(Option=Inputs2Labels;Option=OutputLabels),
	not((member(Item4a,Option),
        Item4a=[Item4,_Type1,_Range4,_ItemNumber4,_Position4],
        Item4=Item5)).

%%        append(Relations3,[[Item3,Range3,ItemNumber3,Position3],[Item4,Range4,ItemNumber4,Position4]],Relations2)

deleteduplicates([],List,List) :- !.
deleteduplicates(List1,List2,List3) :-
        %%((not(List1=[])->
	List1=[[[Item1,Type1,Range1,ItemNumber1,Position1],[Item2,Type2,Range2,ItemNumber2,Position2]]|Rest],
        delete(Rest,[[_Item12,Type1,Range1,ItemNumber3,Position1],[_Item22,Type2,Range2,ItemNumber4,Position2]],Rest2), %% does vv need deleting too v
	delete(Rest2,[[_Item23,Type2,Range2,ItemNumber4,Position2],[_Item13,Type1,Range1,ItemNumber3,Position1]],Rest3),
	ItemNumber1=ItemNumber2,ItemNumber1=ItemNumber3,ItemNumber1=ItemNumber4,
        append(List2,[[[Item1,Type1,Range1,ItemNumber1,Position1],[Item2,Type2,Range2,ItemNumber2,Position2]]],List4),
        deleteduplicates(Rest3,List4,List3),
	%%);(
%%writeln(here1),
  %%      List3=[]))
	!.

deleteduplicates2([],List,List) :- !.
deleteduplicates2(List1,List2,List3) :-
	List1=[Item|Rest1],
	delete(List2,Item,List5),
	deleteduplicates2(Rest1,List5,List3),
	!.

findprogram(_FunctionName,Relations,FunctionNumber,Program,Program) :-
	not(member([[_Item1,_Type1,_Range1,FunctionNumber,_Position1],[_Item2,_Type2,_Range2,FunctionNumber,_Position2]],Relations)),
	!.
findprogram(FunctionName,Relations,FunctionNumber1,Program1,Program2) :-
	%%findprogram2(Relations,FunctionNumber1,1,[],Vars,[],Header,[],Body1),
        input1arguments(Relations,FunctionNumber1,1,[[undef,[v,"`"]]],Vars1,[],Header1,[],TypeStatements1),
	inputs2arguments(Relations,FunctionNumber1,1,Vars1,Vars2,[],Header2,[],TypeStatements2),
	deleteduplicates2(TypeStatements1,TypeStatements2,TypeStatements3),
	outputarguments(Relations,FunctionNumber1,1,Vars2,Vars3,[],Header3),
        extrasarguments(Relations,FunctionNumber1,1,Vars3,_Vars4,[],Header4),
	(not(Header4=[])->
	makecode(FunctionName,Header1,TypeStatements1,TypeStatements3,Header2,Header3,Code1);
        makecode(FunctionName,Header1,TypeStatements1,TypeStatements3,Header2,Header3,Header4,Code1)),
	%%processcode(
	append(Program1,Code1,Program3),
	FunctionNumber2 is FunctionNumber1 + 1,
	findprogram(FunctionName,Relations,FunctionNumber2,Program3,Program2).	

input1arguments(_Relations,_FunctionNumber,3,Vars,Vars,Header,Header,TypeStatements,TypeStatements).
input1arguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2,TypeStatements1,TypeStatements2) :-
	(member([[Item1,Type1,input1,FunctionNumber,Position1],[Item1,_Type2,_Range2,FunctionNumber,_Position2]],Relations);member([[Item1,_Type2,_Range2,FunctionNumber,_Position2],[Item1,Type1,input1,FunctionNumber,Position1]],Relations)),
        var(Item1,Var,Vars1,Vars3),
        append(Header1,[Var],Header3),
	Position2 is Position1 + 1,
	append(TypeStatements1,[[Type1,[Var]]],TypeStatements3), %% add to lpi
	input1arguments(Relations,FunctionNumber,Position2,Vars3,Vars2,Header3,Header2,TypeStatements3,TypeStatements2).
input1arguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2,TypeStatements1,TypeStatements2) :-
	not((member([[Item1,Type1,input1,FunctionNumber,Position1],[Item1,_Type2,_Range2,FunctionNumber,_Position2]],Relations);member([[Item1,_Type22,_Range22,FunctionNumber,_Position22],[Item1,Type1,input1,FunctionNumber,Position1]],Relations))),
	append(Header1,[undef],Header3), %% check this works in lpi
        Position2 is Position1 + 1,
        input1arguments(Relations,FunctionNumber,Position2,Vars1,Vars2,Header3,Header2,TypeStatements1,TypeStatements2).

inputs2arguments(_Relations,_FunctionNumber,3,Vars,Vars,Header,Header,TypeStatements,TypeStatements).
inputs2arguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2,TypeStatements1,TypeStatements2) :-
        (member([[Item1,Type1,inputs2,FunctionNumber,Position1],[Item1,_Type2,_Range2,FunctionNumber,_Position2]],Relations);member([[Item1,_Type2,_Range2,FunctionNumber,_Position2],[Item1,Type1,inputs2,FunctionNumber,Position1]],Relations)),
	var(Item1,Var,Vars1,Vars3),
        append(Header1,[Var],Header3),
        Position2 is Position1 + 1,
        append(TypeStatements1,[[Type1,[Var]]],TypeStatements3),
        inputs2arguments(Relations,FunctionNumber,Position2,Vars3,Vars2,Header3,Header2,TypeStatements3,TypeStatements2).
inputs2arguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2,TypeStatements1,TypeStatements2) :-
        not((member([[Item1,Type1,inputs2,FunctionNumber,Position1],[Item1,_Type2,_Range2,FunctionNumber,_Position2]],Relations);member([[Item1,_Type22,_Range22,FunctionNumber,_Position22],[Item1,Type1,inputs2,FunctionNumber,Position1]],Relations))),
        append(Header1,[undef],Header3), %% check this works in lpi
        Position2 is Position1 + 1,
        inputs2arguments(Relations,FunctionNumber,Position2,Vars1,Vars2,Header3,Header2,TypeStatements1,TypeStatements2).

outputarguments(_Relations,_FunctionNumber,3,Vars,Vars,Header,Header).
outputarguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2) :-
        (member([[Item1,_Type1,output,FunctionNumber,Position1],[Item1,_Type2,_Range2,FunctionNumber,_Position2]],Relations);member([[Item1,_Type22,_Range22,FunctionNumber,_Position22],[Item1,_Type12,output,FunctionNumber,Position1]],Relations)),
        var(Item1,Var,Vars1,Vars3),
        append(Header1,[Var],Header3),
        Position2 is Position1 + 1,
        outputarguments(Relations,FunctionNumber,Position2,Vars3,Vars2,Header3,Header2).
outputarguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2) :-
        not((member([[Item1,Type1,output,FunctionNumber,Position1],[Item1,_Type2,_Range2,FunctionNumber,_Position2]],Relations);member([[Item1,_Type22,_Range22,FunctionNumber,_Position22],[Item1,Type1,output,FunctionNumber,Position1]],Relations))),
        append(Header1,[undef],Header3), %% check this works in lpi
        Position2 is Position1 + 1,
        outputarguments(Relations,FunctionNumber,Position2,Vars1,Vars2,Header3,Header2).

extrasarguments(_Relations,_FunctionNumber,3,Vars,Vars,Header,Header).
extrasarguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2) :-
        member([extrarelation,Item1,_Type1,_Range,FunctionNumber,Position1],Relations),
        var(Item1,Var,Vars1,Vars3),
        append(Header1,[Var],Header3),
        Position2 is Position1 + 1,
        extrasarguments(Relations,FunctionNumber,Position2,Vars3,Vars2,Header3,Header2).
extrasarguments(Relations,FunctionNumber,Position1,Vars1,Vars2,Header1,Header2) :-
        not(member([extrarelation,_Item1,_Type1,_Range,FunctionNumber,Position1],Relations)),
        append(Header1,[undef],Header3), %% check this works in lpi
        Position2 is Position1 + 1,
        extrasarguments(Relations,FunctionNumber,Position2,Vars1,Vars2,Header3,Header2).

makebasecase(FunctionName,Code) :- %****
	Code=[[FunctionName,[[],[v,inputs2],[v,output],[v,output]]]].
makecode(FunctionName,Header1,TypeStatements1,TypeStatements2,Header2,Header3,Code) :-
	append([[v,head]],[Header1],List1),
	append([[v,inputs21]],[Header2],List2),
	append([[v,item1]],[Header3],List3),
	Code=[
		[FunctionName,[[v,input1],[v,inputs2],[v,inputs3],[v,output]],":-",
		[
			[[n,head],[[v,input1],[v,head]]],
			[[n,tail],[[v,input1],[v,tail]]],
			[[n,equals1],List1],
			TypeStatements1,
			[[n,member2],[[v,inputs2],[v,inputs21]]], %% brackets here in new lpi
			[[n,equals1],List2],
			TypeStatements2,
			[[n,equals2],List3],
			[[n,wrap],[[v,item1],[v,item1a]]],
			[[n,append],[[v,inputs3],[v,item1a],[v,item2]]], %% brackets here in new lpi
			[FunctionName,[[v,tail],[v,inputs2],[v,item2],[v,output]]
]]
		
	]].
makebasecase2(FunctionName,Code) :-
        Code=[[FunctionName,[[],[v,inputs2],[v,extras],[v,extras],[v,output],[v,output]]]].
makecode(FunctionName,Header1,TypeStatements1,TypeStatements2,Header2,Header3,Header4,Code) :-
	append([[v,head]],[Header1],List1),
	append([[v,inputs21]],[Header2],List2),
	append([[v,item1]],[Header3],List3),
	append([[v,item3]],[Header4],List4),
        Code=[
                [FunctionName,[[v,input1],[v,inputs2],[v,extras1],[v,extras2],[v,inputs3],[v,output]],":-",
                [
                        [[n,head],[[v,input1],[v,head]]],
                        [[n,tail],[[v,input1],[v,tail]]],
                        [[n,equals1],List1],
			TypeStatements1,
                        [[n,member2],[[v,inputs2],[v,inputs21]]], %% brackets here in new lpi
                        [[n,equals1],List2],
			TypeStatements2,
                        [[n,equals2],List3],
			TypeStatements2,
                        [[n,wrap],[[v,item1],[v,item1a]]],
                        [[n,append],[[v,inputs3],[v,item1a],[v,item2]]], %% brackets here in new lpi
			[[n,equals2],List4],
			[[n,append],[[v,extras1],[v,item3],[v,extras2]]],
                        [FunctionName,[[v,tail],[v,inputs2],[v,item2],[v,output]]
]
                ]
            ]
        ].

findprogram2(Relations,FunctionNumber,ArgumentNumber1,Vars1,Vars2,Header1,Header2,Body1,Body2) :-
	ArgumentNumber2 is ArgumentNumber1 + 1,
	findprogram2(Relations,FunctionNumber,ArgumentNumber2,Vars1,Vars2,Header1,Header2,Body1,Body2).
/**processcode( 
	deleteduplicatecode(
	optimisecode(**/
var(Item,Var,Vars,Vars) :-
	member([Item,Var],Vars).
var(Item1,Var1A,Vars1,Vars2) :-
	length(Vars1,Vars1Length1),
	Vars1Length2 is Vars1Length1-1,
	length(Vars3,Vars1Length2),
	append(Vars3,[[_Item2,[v,Var2]]],Vars1),
	char_code(Var2,Var2Code1),
	Var2Code2 is Var2Code1 + 1,
	Var2Code2 =< 122,
	char_code(Var1,Var2Code2),
	Var1A=[v,Var1],
	append(Vars1,[[Item1,[v,Var1]]],Vars2).
	
/**

fp2
-() 2v in is2,o

- convert to var a,b,c, etc.
- append varname to header, command to body
2p of vars
remove duplicate code
merge code, i.e. m
efmar

	%% if vals are same, then do something, e.g. write empty, otherwise put them together
	%% () if e.g. firstargs are needed, do same treating it as an output, test if same vals affects it
1. o->is, rec type,pos,identicalness format of o (any empty, etc), is
	a. lack of presence in empty in is2, or identicalness in i1, is2,->firstargs added to - in [n,n], one n from each of i1, is2
2. is->o, code

finds mp with 1 or 2 in i1, unless is2 has 1-length tuples - then processes i1, is2 simultanenously

order:
[]
format
type
identicalness

**/
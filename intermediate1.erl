-module(intermediate1).
-export([run/0]).

combinations(_Ops, 0, Acc) -> Acc ;
combinations(Ops, Count, Acc) ->
  New_acc = [[X | Y] || X <- Ops, Y <- Acc],
  combinations(Ops, Count-1, New_acc).

combine_digits(X, Y) when X < 0 -> X*10 - Y ;
combine_digits(X, Y)            -> X*10 + Y.

to_exprs(_, [], Acc)                  -> lists:reverse(Acc) ;
to_exprs(I, [combine | Ops], [H | T]) -> to_exprs(I+1, Ops, [combine_digits(H,I) | T]) ;
to_exprs(I, [subtract | Ops], Acc)    -> to_exprs(I+1, Ops, [ -I | Acc]) ;
to_exprs(I, [add | Ops], Acc)         -> to_exprs(I+1, Ops, [ I | Acc]).

exprs_to_string([], [])              -> [] ;
exprs_to_string([], Acc)             -> lists:nthtail(3, Acc) ;
exprs_to_string([Expr | Exprs], Acc) ->
  Acc1 = Acc ++ if Expr > 0 -> " + " ++ integer_to_list(Expr) ;
                   true     -> " - " ++ integer_to_list(-1 * Expr)
                end,
  exprs_to_string(Exprs, Acc1).

run() ->
  Combos = combinations([add,subtract,combine],8, [[]]),
  lists:map(fun (Exprs) -> exprs_to_string(Exprs,"") end, 
    lists:filter(fun (Exprs) -> lists:sum(Exprs) == 100 end, 
      lists:map(fun (Combo) -> to_exprs(2, Combo, [1]) end, Combos))).

ScatteredPlotTikZ:=function(l)
    local tikz,p, xs, ys, xt, yt;
    if not IsMatrix(l) then
        Error("The arguments must be lists of non negative integers with the same length, or a list of such lists");
    elif not ForAll(l, l -> Length(l)=2 and ForAll(l,x -> IsInt(x))) then
        Error("The arguments must be lists of non negative integers with the same length, or a list of such lists");
    fi;    
    
    xs:=Set(l,x->x[1]);
    ys:=Set(l,y->y[1]);
    xt:=Concatenation("{",String(xs[1]));
    for p in xs{[2..Length(xs)]} do xt:=Concatenation(xt,", ",String(p));
    od;
    xt:=Concatenation(xt,"}");
   
    yt:=Concatenation("{",String(ys[1]));
    for p in ys{[2..Length(xs)]} do yt:=Concatenation(yt,", ",String(p));
    od;
    yt:=Concatenation(yt,"}");
    
    tikz:=Concatenation("\\begin{axis}[grid=both, xtick=",xt,", ytick=",yt,"]\n",                  
                  "\\addplot [only marks] coordinates {\n");
    for p in l do
        tikz:=Concatenation(tikz,"(",String(p[1]),",",String(p[2]),")\n");
    od;
    tikz:=Concatenation(tikz,"};\n","\\end{axis}\n");
    return tikz;
    
end;

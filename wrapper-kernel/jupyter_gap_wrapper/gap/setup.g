#  Unbind(PrintPromptHook);

# Set the prompt to something that pexpect can
# handle
BindGlobal("PrintPromptHook",
function()
    local cp;
    cp := CPROMPT();
    if cp = "gap> " then
      cp := "gap|| ";
    fi;
    if Length(cp)>0 and cp[1] = 'b' then
      cp := "brk|| ";
    fi;
    if Length(cp)>0 and cp[1] = '>' then
      cp := "||";
    fi;
    PRINT_CPROMPT(cp);
end);

# This is a rather basic helper function to do
# completion. It is related to the completion
# function provided in lib/cmdledit.g in the GAP
# distribution
BindGlobal("JupyterCompletion",
function(tok)
  local cand, i;

  cand := IDENTS_BOUND_GVARS();

  for i in cand do
    if PositionSublist(i, tok) = 1 then
      Print(i, "\n");
    fi;
  od;
end);

# This is a really ugly hack, but at the moment
# it works nicely enough to demo stuff.
# In the future we might want to dump the dot
# into a temporary file and then exec dot on it.
BindGlobal("JupyterDotSplash",
function(dot)
    local fn, fd;

    fn := TmpName();
    fd := IO_File(fn, "w");
    IO_Write(fd, dot);
    IO_Close(fd);

    Exec("dot","-Tsvg",fn);

    IO_unlink(fn);
end);

BindGlobal("JupyterTikZSplash",
function(tikz)
    local fn, header, rnd, ltx, svgfile, stream, svgdata, szscr;
    
    header:=Concatenation(
                    "\\documentclass[crop,tikz]{standalone}\n", 
                    "\\usepackage{pgfplots}",
                    "\\makeatletter\n",
                    "\\batchmode\n",
                    "\\nonstopmode\n",
                    "\\begin{document}",
            "\\begin{tikzpicture}");
    header:=Concatenation(header, tikz);
    header:=Concatenation(header,"\\end{tikzpicture}\n\\end{document}");
    
    rnd:=String(Random([0..1000]));
    fn := Concatenation("svg_get",rnd);
    
    PrintTo(Concatenation(fn,".tex"),header);
    
    ltx:=Concatenation("pdflatex -shell-escape  ", 
        Concatenation(fn, ".tex")," > ",Concatenation(fn, ".log2"));
    Exec(ltx);

    if not(IsExistingFile( Concatenation(fn, ".pdf") )) then
        Print("No pdf was created; pdflatex is installed in your system?");
    else
        svgfile:=Concatenation(fn,".svg");
        ltx:=Concatenation("pdf2svg ", Concatenation(fn, ".pdf"), " ",
            svgfile, " >> ",Concatenation(fn, ".log2"));
        Exec(ltx);
    
        if not(IsExistingFile(svgfile)) then
            Print("No svg was created; pdf2svg is installed in your system?");
        else
            stream := InputTextFile( svgfile );
            if stream <> fail then
                szscr := SizeScreen();
                svgdata := ReadAll( stream );
                CloseStream( stream );
                SizeScreen( [Length( svgdata ), szscr[2]] );
                Print( svgdata );
                SizeScreen( szscr );
            else
                Print( "Unable to render ", tikz );
            fi;
            RemoveFile( svgfile );
        fi;
    fi;

    if IsExistingFile( Concatenation(fn, ".log") ) then
        RemoveFile( Concatenation(fn, ".log") );
    fi;
    if IsExistingFile( Concatenation(fn, ".log2") ) then
        RemoveFile( Concatenation(fn, ".log2") );
    fi;
    if IsExistingFile( Concatenation(fn, ".aux") ) then
        RemoveFile( Concatenation(fn, ".aux") );
    fi;
    if IsExistingFile( Concatenation(fn, ".pdf") ) then
        RemoveFile( Concatenation(fn, ".pdf") );
    fi;
    if IsExistingFile( Concatenation(fn, ".tex") ) then
        RemoveFile( Concatenation(fn, ".tex") );
    fi;
end);


# The following are needed to make the help system
# sort of play nice with the wrapper kernel
SetUserPreference("browse", "SelectHelpMatches", false);
SetUserPreference("Pager", "cat");
SetUserPreference("PagerOptions", "");
SizeScreen([4096,24]);
# Display help in browser not a good option for servers
# SetUserPreference( "HelpViewers", ["browser"])

% NiCad file extractor, Swift
% Jim Cordy, July 2020

% NiCad tag grammar
include "nicad.grm"

% Using Swift 5.2 grammar
include "swift.grm"

% Ignore BOM headers from Windows
include "bom.grm"

% Redefinitions to collect source coordinates for function definitions as parsed input,
% and to allow for XML markup of function definitions as output

redefine program
	% Input form 
	[srcfilename] [srclinenumber] 		% Keep track of starting file and line number
	[top_level_declaration]
        [srcfilename] [srclinenumber] 		% Keep track of ending file and line number
    |
	% Output form 
        [not input] 				% disallow output form in input parse
	[opt xml_source_coordinate]
	[top_level_declaration]
	[opt end_xml_source_coordinate]
end redefine

define input
	[token] | [key]
end define


% Main function - extract and mark up parsed input program
function main
    replace [program]
	P [program]
    by 
    	P [convertProgram]
end function

rule convertProgram
    skipping [program]
    replace [program]
	FileName [srcfilename] LineNumber [srclinenumber]
	FileContents [top_level_declaration]
        EndFileName [srcfilename] EndLineNumber [srclinenumber]

    % Convert file name and line numbers to strings for XML
    construct FileNameString [stringlit]
	_ [quote FileName] 
    construct OneString [stringlit]
	_ [quote '1] 
    construct EndLineNumberString [stringlit]
	_ [quote EndLineNumber] 

    % Output is XML form with attributes indicating input source coordinates
    construct XmlHeader [xml_source_coordinate]
	'<source file=FileNameString startline=OneString endline=EndLineNumberString>
    by
	XmlHeader
	FileContents [removeOptSemis] 
	'</source>
end rule

rule removeOptSemis
    replace [opt ';]
	';
    by
	% none
end rule

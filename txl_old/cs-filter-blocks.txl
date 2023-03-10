% NiCad filter given nonterminals from potential clones - C# block version
% Jim Cordy, May 2010

% NiCad tag grammar
include "nicad.grm"

% Using C# grammar
include "csharp.grm"

% Redefinition for potential clones
redefine block
    { [IN] [NL]
	[opt statement_list] [EX]
    } [NL]
end redefine

define potential_clone
    [block]
end define

% Generic filter
include "generic-filter.rul"


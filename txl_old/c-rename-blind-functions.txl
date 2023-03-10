% NiCad blind renaming - C functions
% Jim Cordy, May 2010

% Rev 19.5.20 JRC - Added blind renaming for numeric and string literals

% NiCad tag grammar
include "nicad.grm"

% Using Gnu C grammar
include "c.grm"

redefine function_definition
    [function_header]
    [opt KP_parameter_decls]
    '{                              [IN][NL]
        [compound_statement_body]   [EX]
    '}
end redefine

define potential_clone
    [function_definition]
end define

% Make sure that C grammar robustness does not eat NiCad tags
redefine unknown_declaration_or_statement
    [not endsourcetag] ...
end redefine

% Generic blind renaming
include "generic-rename-blind.rul"

% Literal renaming for C
include "c-rename-literals.rul"

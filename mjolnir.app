%% This is the application resource file (.app file) for the 'base' 
%% application. 
{application, mjolnir, 
[{description, "Gazing Over The Mighty Chalice Between Pagan Northlands"}, 
{vsn, "1.0"},
{modules, [mjolnir_app, mjolnir_server, mjolnir_bot]}, 
{registered,[]}, 
{applications, [kernel,stdlib]}, 
{mod, {mjolnir_app,[]}}, 
{start_phases, []} 
]}.

"copied from monty's work here: https://github.com/MagLev/maglev-topaz-scripts"
set gemstone seaside user DataCurator password swordfish
login
run
|autoCommit autoMigrate|
(GsFile openWriteOnServer: '/opt/scripts/seasideLoaded') nextPutAll: '1'; close.
autoCommit:= MCPlatformSupport autoCommit.
autoMigrate:= MCPlatformSupport autoMigrate.
MCPlatformSupport autoCommit: true.
MCPlatformSupport autoMigrate: true.

MCPlatformSupport commitOnAlmostOutOfMemoryDuring: [
                  Metacello new     
                     baseline: '{{project_name}}';
                     repository: '{{project_repository}}';
                     onConflict: [:ex | ex allow];
                     onLock: [:ex | ex honor];
                     load: #('Core' 'Examples' 'Zinc-Seaside' 'REST' 'Seaside-Adaptors-FastCGI')
       
].
System commitTransaction.

MCPlatformSupport autoCommit: autoCommit.
MCPlatformSupport autoMigrate: autoMigrate.
System commitTransaction.
(GsFile openWriteOnServer:'/opt/scripts/seasideLoaded') nextPutAll:'0'; close.

%
logout

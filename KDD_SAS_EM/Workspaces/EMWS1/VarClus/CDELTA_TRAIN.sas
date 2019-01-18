if upcase(strip(ROLE))='INPUT' and upcase(strip(LEVEL))='INTERVAL' then do;
if upcase(strip(NAME)) in (
"NUM_OUT_CMDS"
"CLUS1"
"CLUS10"
"CLUS2"
"CLUS3"
"CLUS4"
"CLUS5"
"CLUS6"
"CLUS7"
"CLUS8"
"CLUS9"
) then ROLE="INPUT";
else ROLE="REJECTED";
end;
if upcase(strip(ROLE)) = "REJECTED" then delete ;

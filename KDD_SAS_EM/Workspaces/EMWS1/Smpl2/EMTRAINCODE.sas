*------------------------------------------------------------*;
* Smpl2: Retrieving stratification variable(s) levels;
*------------------------------------------------------------*;
proc freq data=EMWS1.Part_TRAIN noprint;
format
type $16.
;
table
type
/out=EMWS1.Smpl2_STRATASUMMARY (rename=(count=_npop_ percent=_pctpop_)) missing;
run;
quit;
proc sort data=EMWS1.Smpl2_STRATASUMMARY out=EMWS1.Smpl2_STRATASUMMARY;
by descending _npop_;
run;
*------------------------------------------------------------*;
* Smpl2: Create stratified sample;
*------------------------------------------------------------*;
data EMWS1.Smpl2_DATA(label="Sample of EMWS1.Part_TRAIN.");
set EMWS1.Part_TRAIN;
retain _seed_ 12345;
label _dataobs_ = "%sysfunc(sasmsg(sashelp.dmine, sample_dataobs_vlabel, NOQUOTE))";
drop _seed_ _genvalue_;
call ranuni(_seed_, _genvalue_);
drop
_n000001 _s000001
_n000002 _s000002
_n000003 _s000003
_n000004 _s000004
_n000005 _s000005
_n000006 _s000006
_n000007 _s000007
_n000008 _s000008
_n000009 _s000009
_n000010 _s000010
_n000011 _s000011
_n000012 _s000012
_n000013 _s000013
_n000014 _s000014
_n000015 _s000015
_n000016 _s000016
_n000017 _s000017
_n000018 _s000018
_n000019 _s000019
_n000020 _s000020
_n000021 _s000021
_n000022 _s000022
_n000023 _s000023
;
length _Sformat1 $200;
drop _Sformat1;
_Sformat1 = strip(put(type, $16.));
if
_Sformat1 = 'smurf.'
then do;
_n000001 + 1;
if _s000001 < 56158 then do;
if _genvalue_*(112316 - _n000001) <=(56158 - _s000001) then do;
_s000001 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'neptune.'
then do;
_n000002 + 1;
if _s000002 < 21440 then do;
if _genvalue_*(42879 - _n000002) <=(21440 - _s000002) then do;
_s000002 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'normal.'
then do;
_n000003 + 1;
if _s000003 < 19456 then do;
if _genvalue_*(38911 - _n000003) <=(19456 - _s000003) then do;
_s000003 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'back.'
then do;
_n000004 + 1;
if _s000004 < 441 then do;
if _genvalue_*(881 - _n000004) <=(441 - _s000004) then do;
_s000004 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'satan.'
then do;
_n000005 + 1;
if _s000005 < 318 then do;
if _genvalue_*(635 - _n000005) <=(318 - _s000005) then do;
_s000005 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'ipsweep.'
then do;
_n000006 + 1;
if _s000006 < 249 then do;
if _genvalue_*(498 - _n000006) <=(249 - _s000006) then do;
_s000006 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'portsweep.'
then do;
_n000007 + 1;
if _s000007 < 208 then do;
if _genvalue_*(416 - _n000007) <=(208 - _s000007) then do;
_s000007 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'warezclient.'
then do;
_n000008 + 1;
if _s000008 < 204 then do;
if _genvalue_*(408 - _n000008) <=(204 - _s000008) then do;
_s000008 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'teardrop.'
then do;
_n000009 + 1;
if _s000009 < 196 then do;
if _genvalue_*(392 - _n000009) <=(196 - _s000009) then do;
_s000009 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'pod.'
then do;
_n000010 + 1;
if _s000010 < 53 then do;
if _genvalue_*(106 - _n000010) <=(53 - _s000010) then do;
_s000010 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'nmap.'
then do;
_n000011 + 1;
if _s000011 < 46 then do;
if _genvalue_*(92 - _n000011) <=(46 - _s000011) then do;
_s000011 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'guess_passwd.'
then do;
_n000012 + 1;
if _s000012 < 11 then do;
if _genvalue_*(21 - _n000012) <=(11 - _s000012) then do;
_s000012 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'buffer_overflow.'
then do;
_n000013 + 1;
if _s000013 < 6 then do;
if _genvalue_*(11 - _n000013) <=(6 - _s000013) then do;
_s000013 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'land.'
then do;
_n000014 + 1;
if _s000014 < 5 then do;
if _genvalue_*(8 - _n000014) <=(5 - _s000014) then do;
_s000014 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'warezmaster.'
then do;
_n000015 + 1;
if _s000015 < 5 then do;
if _genvalue_*(8 - _n000015) <=(5 - _s000015) then do;
_s000015 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'imap.'
then do;
_n000016 + 1;
if _s000016 < 5 then do;
if _genvalue_*(5 - _n000016) <=(5 - _s000016) then do;
_s000016 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'loadmodule.'
then do;
_n000017 + 1;
if _s000017 < 4 then do;
if _genvalue_*(4 - _n000017) <=(4 - _s000017) then do;
_s000017 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'rootkit.'
then do;
_n000018 + 1;
if _s000018 < 4 then do;
if _genvalue_*(4 - _n000018) <=(4 - _s000018) then do;
_s000018 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'ftp_write.'
then do;
_n000019 + 1;
if _s000019 < 3 then do;
if _genvalue_*(3 - _n000019) <=(3 - _s000019) then do;
_s000019 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'multihop.'
then do;
_n000020 + 1;
if _s000020 < 2 then do;
if _genvalue_*(2 - _n000020) <=(2 - _s000020) then do;
_s000020 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'phf.'
then do;
_n000021 + 1;
if _s000021 < 2 then do;
if _genvalue_*(2 - _n000021) <=(2 - _s000021) then do;
_s000021 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'spy.'
then do;
_n000022 + 1;
if _s000022 < 2 then do;
if _genvalue_*(2 - _n000022) <=(2 - _s000022) then do;
_s000022 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
else if
_Sformat1 = 'perl.'
then do;
_n000023 + 1;
if _s000023 < 1 then do;
if _genvalue_*(1 - _n000023) <=(1 - _s000023) then do;
_s000023 + 1;
_dataobs_=_N_;
output;
end;
end;
end;
run;

*------------------------------------------------------------*;
* Neural2: Create decision matrix;
*------------------------------------------------------------*;
data WORK.attack_type(label="attack_type");
  length   attack_type                      $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="NORM"
           DECISION2="DOS"
           ;
attack_type="NORM"; COUNT=39768; DATAPRIOR=0.13403618518618; TRAINPRIOR=0.13403618518618; DECPRIOR=.; DECISION1=1; DECISION2=0;
output;
attack_type="DOS"; COUNT=256928; DATAPRIOR=0.86596381481381; TRAINPRIOR=0.86596381481381; DECPRIOR=.; DECISION1=0; DECISION2=1;
output;
;
run;
proc datasets lib=work nolist;
modify attack_type(type=PROFIT label=attack_type);
label DECISION1= 'NORM';
label DECISION2= 'DOS';
run;
quit;
data EM_Neural2;
set EMWS1.Varsel_TRAIN(keep=
attack_type count dst_host_diff_srv_rate dst_host_same_src_port_rate
dst_host_serror_rate logged_in protocol service srv_serror_rate );
run;
*------------------------------------------------------------* ;
* Neural2: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    attack_type(DESC) logged_in(ASC) protocol(ASC) service(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Neural2: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    count dst_host_diff_srv_rate dst_host_same_src_port_rate dst_host_serror_rate
   srv_serror_rate
%mend DMDBVar;
*------------------------------------------------------------*;
* Neural2: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_Neural2
dmdbcat=WORK.Neural2_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
attack_type
;
run;
quit;
*------------------------------------------------------------* ;
* Neural2: Interval Input Variables Macro ;
*------------------------------------------------------------* ;
%macro INTINPUTS;
    count dst_host_diff_srv_rate dst_host_same_src_port_rate dst_host_serror_rate
   srv_serror_rate
%mend INTINPUTS;
*------------------------------------------------------------* ;
* Neural2: Binary Inputs Macro ;
*------------------------------------------------------------* ;
%macro BININPUTS;
    logged_in
%mend BININPUTS;
*------------------------------------------------------------* ;
* Neural2: Nominal Inputs Macro ;
*------------------------------------------------------------* ;
%macro NOMINPUTS;
    protocol service
%mend NOMINPUTS;
*------------------------------------------------------------* ;
* Neural2: Ordinal Inputs Macro ;
*------------------------------------------------------------* ;
%macro ORDINPUTS;

%mend ORDINPUTS;
*------------------------------------------------------------*;
* Neural Network Training;
;
*------------------------------------------------------------*;
proc neural data=EM_Neural2 dmdbcat=WORK.Neural2_DMDB
random=12345
;
nloptions
;
performance alldetails noutilfile;
netopts
decay=0;
input %INTINPUTS / level=interval id=intvl
;
input %BININPUTS / level=nominal id=bin
;
input %NOMINPUTS / level=nominal id=nom
;
target attack_type / level=NOMINAL id=attack_type
bias
;
arch MLP
Hidden=3
;
save network=EMWS1.Neural2_NETWORK.dm_neural;
train Maxiter=50
maxtime=14400
Outest=EMWS1.Neural2_outest estiter=1
Outfit=EMWS1.Neural2_OUTFIT
;
run;
quit;
proc sort data=EMWS1.Neural2_OUTFIT(where=(_iter_ ne . and _NAME_="OVERALL")) out=fit_Neural2;
by _AVERR_;
run;
%GLOBAL ITER;
data _null_;
set fit_Neural2(obs=1);
call symput('ITER',put(_ITER_, 6.));
run;
data EMWS1.Neural2_INITIAL;
set EMWS1.Neural2_outest(where=(_ITER_ eq &ITER and _OBJ_ ne .));
run;
*------------------------------------------------------------*;
* Neural Network Model Selection;
;
*------------------------------------------------------------*;
proc neural data=EM_Neural2 dmdbcat=WORK.Neural2_DMDB
network = EMWS1.Neural2_NETWORK.dm_neural
random=12345
;
nloptions noprint;
performance alldetails noutilfile;
initial inest=EMWS1.Neural2_INITIAL;
train tech=NONE;
code file="C:\Users\Dinis\Google Drive\Intelligent_Systems_MSc\Artificial_Neural_Networks\Assignments\KDD Project\KDD_SAS\Workspaces\EMWS1\Neural2\SCORECODE.sas"
group=Neural2
;
;
code file="C:\Users\Dinis\Google Drive\Intelligent_Systems_MSc\Artificial_Neural_Networks\Assignments\KDD Project\KDD_SAS\Workspaces\EMWS1\Neural2\RESIDUALSCORECODE.sas"
group=Neural2
residual
;
;
score data=EMWS1.Varsel_TRAIN out=_NULL_
outfit=WORK.FIT1
role=TRAIN
outkey=EMWS1.Neural2_OUTKEY;
score data=EMWS1.Varsel_TEST out=_NULL_
outfit=WORK.FIT2
role=TEST
outkey=EMWS1.Neural2_OUTKEY;
run;
quit;
data EMWS1.Neural2_OUTFIT;
merge WORK.FIT1 WORK.FIT2;
run;
data EMWS1.Neural2_EMESTIMATE;
set EMWS1.Neural2_outest;
if _type_ ^in('HESSIAN' 'GRAD');
run;
proc datasets lib=work nolist;
delete EM_Neural2;
run;
quit;

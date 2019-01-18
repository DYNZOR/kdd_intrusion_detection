***********************************;
*** Begin Scoring Code for Neural;
***********************************;
DROP _DM_BAD _EPS _NOCL_ _MAX_ _MAXP_ _SUM_ _NTRIALS;
 _DM_BAD = 0;
 _NOCL_ = .;
 _MAX_ = .;
 _MAXP_ = .;
 _SUM_ = .;
 _NTRIALS = .;
 _EPS =                1E-10;
LENGTH _WARN_ $4
      I_attack_type  $ 5
      U_attack_type  $ 5
;
      label S_count = 'Standard: count' ;

      label S_dst_host_diff_srv_rate = 'Standard: dst_host_diff_srv_rate' ;

      label S_dst_host_same_src_port_rate =
'Standard: dst_host_same_src_port_rate' ;

      label S_dst_host_serror_rate = 'Standard: dst_host_serror_rate' ;

      label S_srv_serror_rate = 'Standard: srv_serror_rate' ;

      label logged_in0 = 'Dummy: logged_in=0' ;

      label protocolicmp = 'Dummy: protocol=icmp' ;

      label protocoltcp = 'Dummy: protocol=tcp' ;

      label serviceIRC = 'Dummy: service=IRC' ;

      label serviceX11 = 'Dummy: service=X11' ;

      label serviceZ39_50 = 'Dummy: service=Z39_50' ;

      label serviceauth = 'Dummy: service=auth' ;

      label servicebgp = 'Dummy: service=bgp' ;

      label servicecourier = 'Dummy: service=courier' ;

      label servicecsnet_ns = 'Dummy: service=csnet_ns' ;

      label servicectf = 'Dummy: service=ctf' ;

      label servicedaytime = 'Dummy: service=daytime' ;

      label servicediscard = 'Dummy: service=discard' ;

      label servicedomain = 'Dummy: service=domain' ;

      label servicedomain_u = 'Dummy: service=domain_u' ;

      label serviceecho = 'Dummy: service=echo' ;

      label serviceeco_i = 'Dummy: service=eco_i' ;

      label serviceecr_i = 'Dummy: service=ecr_i' ;

      label serviceefs = 'Dummy: service=efs' ;

      label serviceexec = 'Dummy: service=exec' ;

      label servicefinger = 'Dummy: service=finger' ;

      label serviceftp = 'Dummy: service=ftp' ;

      label serviceftp_data = 'Dummy: service=ftp_data' ;

      label servicegopher = 'Dummy: service=gopher' ;

      label servicehostnames = 'Dummy: service=hostnames' ;

      label servicehttp = 'Dummy: service=http' ;

      label servicehttp_443 = 'Dummy: service=http_443' ;

      label serviceimap4 = 'Dummy: service=imap4' ;

      label serviceiso_tsap = 'Dummy: service=iso_tsap' ;

      label serviceklogin = 'Dummy: service=klogin' ;

      label servicekshell = 'Dummy: service=kshell' ;

      label serviceldap = 'Dummy: service=ldap' ;

      label servicelink = 'Dummy: service=link' ;

      label servicelogin = 'Dummy: service=login' ;

      label servicemtp = 'Dummy: service=mtp' ;

      label servicename = 'Dummy: service=name' ;

      label servicenetbios_dgm = 'Dummy: service=netbios_dgm' ;

      label servicenetbios_ns = 'Dummy: service=netbios_ns' ;

      label servicenetbios_ssn = 'Dummy: service=netbios_ssn' ;

      label servicenetstat = 'Dummy: service=netstat' ;

      label servicennsp = 'Dummy: service=nnsp' ;

      label servicenntp = 'Dummy: service=nntp' ;

      label servicentp_u = 'Dummy: service=ntp_u' ;

      label serviceother = 'Dummy: service=other' ;

      label servicepop_2 = 'Dummy: service=pop_2' ;

      label servicepop_3 = 'Dummy: service=pop_3' ;

      label serviceprinter = 'Dummy: service=printer' ;

      label serviceprivate = 'Dummy: service=private' ;

      label servicered_i = 'Dummy: service=red_i' ;

      label serviceremote_job = 'Dummy: service=remote_job' ;

      label servicerje = 'Dummy: service=rje' ;

      label serviceshell = 'Dummy: service=shell' ;

      label servicesmtp = 'Dummy: service=smtp' ;

      label servicesql_net = 'Dummy: service=sql_net' ;

      label servicessh = 'Dummy: service=ssh' ;

      label servicesunrpc = 'Dummy: service=sunrpc' ;

      label servicesupdup = 'Dummy: service=supdup' ;

      label servicesystat = 'Dummy: service=systat' ;

      label servicetelnet = 'Dummy: service=telnet' ;

      label servicetftp_u = 'Dummy: service=tftp_u' ;

      label servicetime = 'Dummy: service=time' ;

      label serviceurh_i = 'Dummy: service=urh_i' ;

      label serviceurp_i = 'Dummy: service=urp_i' ;

      label serviceuucp = 'Dummy: service=uucp' ;

      label serviceuucp_path = 'Dummy: service=uucp_path' ;

      label servicevmnet = 'Dummy: service=vmnet' ;

      label H11 = 'Hidden: H1=1' ;

      label H12 = 'Hidden: H1=2' ;

      label H13 = 'Hidden: H1=3' ;

      label I_attack_type = 'Into: attack_type' ;

      label U_attack_type = 'Unnormalized Into: attack_type' ;

      label P_attack_typenorm = 'Predicted: attack_type=norm' ;

      label P_attack_typedos = 'Predicted: attack_type=dos' ;

      label  _WARN_ = "Warnings";

*** Generate dummy variables for logged_in ;
drop logged_in0 ;
if missing( logged_in ) then do;
   logged_in0 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( logged_in , BEST. );
   %DMNORMIP( _dm12 )
   if _dm12 = '0'  then do;
      logged_in0 = 1;
   end;
   else if _dm12 = '1'  then do;
      logged_in0 = -1;
   end;
   else do;
      logged_in0 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for protocol ;
drop protocolicmp protocoltcp ;
if missing( protocol ) then do;
   protocolicmp = .;
   protocoltcp = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm4 $ 4; drop _dm4 ;
   _dm4 = put( protocol , $4. );
   %DMNORMIP( _dm4 )
   if _dm4 = 'ICMP'  then do;
      protocolicmp = 1;
      protocoltcp = 0;
   end;
   else if _dm4 = 'TCP'  then do;
      protocolicmp = 0;
      protocoltcp = 1;
   end;
   else if _dm4 = 'UDP'  then do;
      protocolicmp = -1;
      protocoltcp = -1;
   end;
   else do;
      protocolicmp = .;
      protocoltcp = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for service ;
drop serviceIRC serviceX11 serviceZ39_50 serviceauth servicebgp servicecourier
         servicecsnet_ns servicectf servicedaytime servicediscard
        servicedomain servicedomain_u serviceecho serviceeco_i serviceecr_i
        serviceefs serviceexec servicefinger serviceftp serviceftp_data
        servicegopher servicehostnames servicehttp servicehttp_443
        serviceimap4 serviceiso_tsap serviceklogin servicekshell serviceldap
        servicelink servicelogin servicemtp servicename servicenetbios_dgm
        servicenetbios_ns servicenetbios_ssn servicenetstat servicennsp
        servicenntp servicentp_u serviceother servicepop_2 servicepop_3
        serviceprinter serviceprivate servicered_i serviceremote_job
        servicerje serviceshell servicesmtp servicesql_net servicessh
        servicesunrpc servicesupdup servicesystat servicetelnet servicetftp_u
        servicetime serviceurh_i serviceurp_i serviceuucp serviceuucp_path
        servicevmnet ;
*** encoding is sparse, initialize to zero;
serviceIRC = 0;
serviceX11 = 0;
serviceZ39_50 = 0;
serviceauth = 0;
servicebgp = 0;
servicecourier = 0;
servicecsnet_ns = 0;
servicectf = 0;
servicedaytime = 0;
servicediscard = 0;
servicedomain = 0;
servicedomain_u = 0;
serviceecho = 0;
serviceeco_i = 0;
serviceecr_i = 0;
serviceefs = 0;
serviceexec = 0;
servicefinger = 0;
serviceftp = 0;
serviceftp_data = 0;
servicegopher = 0;
servicehostnames = 0;
servicehttp = 0;
servicehttp_443 = 0;
serviceimap4 = 0;
serviceiso_tsap = 0;
serviceklogin = 0;
servicekshell = 0;
serviceldap = 0;
servicelink = 0;
servicelogin = 0;
servicemtp = 0;
servicename = 0;
servicenetbios_dgm = 0;
servicenetbios_ns = 0;
servicenetbios_ssn = 0;
servicenetstat = 0;
servicennsp = 0;
servicenntp = 0;
servicentp_u = 0;
serviceother = 0;
servicepop_2 = 0;
servicepop_3 = 0;
serviceprinter = 0;
serviceprivate = 0;
servicered_i = 0;
serviceremote_job = 0;
servicerje = 0;
serviceshell = 0;
servicesmtp = 0;
servicesql_net = 0;
servicessh = 0;
servicesunrpc = 0;
servicesupdup = 0;
servicesystat = 0;
servicetelnet = 0;
servicetftp_u = 0;
servicetime = 0;
serviceurh_i = 0;
serviceurp_i = 0;
serviceuucp = 0;
serviceuucp_path = 0;
servicevmnet = 0;
if missing( service ) then do;
   serviceIRC = .;
   serviceX11 = .;
   serviceZ39_50 = .;
   serviceauth = .;
   servicebgp = .;
   servicecourier = .;
   servicecsnet_ns = .;
   servicectf = .;
   servicedaytime = .;
   servicediscard = .;
   servicedomain = .;
   servicedomain_u = .;
   serviceecho = .;
   serviceeco_i = .;
   serviceecr_i = .;
   serviceefs = .;
   serviceexec = .;
   servicefinger = .;
   serviceftp = .;
   serviceftp_data = .;
   servicegopher = .;
   servicehostnames = .;
   servicehttp = .;
   servicehttp_443 = .;
   serviceimap4 = .;
   serviceiso_tsap = .;
   serviceklogin = .;
   servicekshell = .;
   serviceldap = .;
   servicelink = .;
   servicelogin = .;
   servicemtp = .;
   servicename = .;
   servicenetbios_dgm = .;
   servicenetbios_ns = .;
   servicenetbios_ssn = .;
   servicenetstat = .;
   servicennsp = .;
   servicenntp = .;
   servicentp_u = .;
   serviceother = .;
   servicepop_2 = .;
   servicepop_3 = .;
   serviceprinter = .;
   serviceprivate = .;
   servicered_i = .;
   serviceremote_job = .;
   servicerje = .;
   serviceshell = .;
   servicesmtp = .;
   servicesql_net = .;
   servicessh = .;
   servicesunrpc = .;
   servicesupdup = .;
   servicesystat = .;
   servicetelnet = .;
   servicetftp_u = .;
   servicetime = .;
   serviceurh_i = .;
   serviceurp_i = .;
   serviceuucp = .;
   serviceuucp_path = .;
   servicevmnet = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm11 $ 11; drop _dm11 ;
   _dm11 = put( service , $11. );
   %DMNORMIP( _dm11 )
   if _dm11 = 'ECR_I'  then do;
      serviceecr_i = 1;
   end;
   else if _dm11 = 'PRIVATE'  then do;
      serviceprivate = 1;
   end;
   else if _dm11 = 'HTTP'  then do;
      servicehttp = 1;
   end;
   else if _dm11 = 'DOMAIN_U'  then do;
      servicedomain_u = 1;
   end;
   else if _dm11 = 'SMTP'  then do;
      servicesmtp = 1;
   end;
   else if _dm11 = 'FTP_DATA'  then do;
      serviceftp_data = 1;
   end;
   else if _dm11 = 'NTP_U'  then do;
      servicentp_u = 1;
   end;
   else if _dm11 = 'FINGER'  then do;
      servicefinger = 1;
   end;
   else if _dm11 = 'ECO_I'  then do;
      serviceeco_i = 1;
   end;
   else if _dm11 = 'TELNET'  then do;
      servicetelnet = 1;
   end;
   else if _dm11 = 'URP_I'  then do;
      serviceurp_i = 1;
   end;
   else if _dm11 = 'AUTH'  then do;
      serviceauth = 1;
   end;
   else if _dm11 = 'OTHER'  then do;
      serviceother = 1;
   end;
   else if _dm11 = 'POP_3'  then do;
      servicepop_3 = 1;
   end;
   else if _dm11 = 'DOMAIN'  then do;
      servicedomain = 1;
   end;
   else if _dm11 = 'CSNET_NS'  then do;
      servicecsnet_ns = 1;
   end;
   else if _dm11 = 'GOPHER'  then do;
      servicegopher = 1;
   end;
   else if _dm11 = 'SQL_NET'  then do;
      servicesql_net = 1;
   end;
   else if _dm11 = 'IMAP4'  then do;
      serviceimap4 = 1;
   end;
   else if _dm11 = 'REMOTE_JOB'  then do;
      serviceremote_job = 1;
   end;
   else if _dm11 = 'SHELL'  then do;
      serviceshell = 1;
   end;
   else if _dm11 = 'DISCARD'  then do;
      servicediscard = 1;
   end;
   else if _dm11 = 'SYSTAT'  then do;
      servicesystat = 1;
   end;
   else if _dm11 = 'DAYTIME'  then do;
      servicedaytime = 1;
   end;
   else if _dm11 = 'TIME'  then do;
      servicetime = 1;
   end;
   else if _dm11 = 'LOGIN'  then do;
      servicelogin = 1;
   end;
   else if _dm11 = 'KLOGIN'  then do;
      serviceklogin = 1;
   end;
   else if _dm11 = 'COURIER'  then do;
      servicecourier = 1;
   end;
   else if _dm11 = 'NNTP'  then do;
      servicenntp = 1;
   end;
   else if _dm11 = 'POP_2'  then do;
      servicepop_2 = 1;
   end;
   else if _dm11 = 'EXEC'  then do;
      serviceexec = 1;
   end;
   else if _dm11 = 'EFS'  then do;
      serviceefs = 1;
   end;
   else if _dm11 = 'LINK'  then do;
      servicelink = 1;
   end;
   else if _dm11 = 'ISO_TSAP'  then do;
      serviceiso_tsap = 1;
   end;
   else if _dm11 = 'FTP'  then do;
      serviceftp = 1;
   end;
   else if _dm11 = 'SUNRPC'  then do;
      servicesunrpc = 1;
   end;
   else if _dm11 = 'ECHO'  then do;
      serviceecho = 1;
   end;
   else if _dm11 = 'BGP'  then do;
      servicebgp = 1;
   end;
   else if _dm11 = 'NNSP'  then do;
      servicennsp = 1;
   end;
   else if _dm11 = 'LDAP'  then do;
      serviceldap = 1;
   end;
   else if _dm11 = 'RJE'  then do;
      servicerje = 1;
   end;
   else if _dm11 = 'CTF'  then do;
      servicectf = 1;
   end;
   else if _dm11 = 'VMNET'  then do;
      servicevmnet = 1;
   end;
   else if _dm11 = 'WHOIS'  then do;
      serviceIRC = -1;
      serviceX11 = -1;
      serviceZ39_50 = -1;
      serviceauth = -1;
      servicebgp = -1;
      servicecourier = -1;
      servicecsnet_ns = -1;
      servicectf = -1;
      servicedaytime = -1;
      servicediscard = -1;
      servicedomain = -1;
      servicedomain_u = -1;
      serviceecho = -1;
      serviceeco_i = -1;
      serviceecr_i = -1;
      serviceefs = -1;
      serviceexec = -1;
      servicefinger = -1;
      serviceftp = -1;
      serviceftp_data = -1;
      servicegopher = -1;
      servicehostnames = -1;
      servicehttp = -1;
      servicehttp_443 = -1;
      serviceimap4 = -1;
      serviceiso_tsap = -1;
      serviceklogin = -1;
      servicekshell = -1;
      serviceldap = -1;
      servicelink = -1;
      servicelogin = -1;
      servicemtp = -1;
      servicename = -1;
      servicenetbios_dgm = -1;
      servicenetbios_ns = -1;
      servicenetbios_ssn = -1;
      servicenetstat = -1;
      servicennsp = -1;
      servicenntp = -1;
      servicentp_u = -1;
      serviceother = -1;
      servicepop_2 = -1;
      servicepop_3 = -1;
      serviceprinter = -1;
      serviceprivate = -1;
      servicered_i = -1;
      serviceremote_job = -1;
      servicerje = -1;
      serviceshell = -1;
      servicesmtp = -1;
      servicesql_net = -1;
      servicessh = -1;
      servicesunrpc = -1;
      servicesupdup = -1;
      servicesystat = -1;
      servicetelnet = -1;
      servicetftp_u = -1;
      servicetime = -1;
      serviceurh_i = -1;
      serviceurp_i = -1;
      serviceuucp = -1;
      serviceuucp_path = -1;
      servicevmnet = -1;
   end;
   else if _dm11 = 'NETBIOS_DGM'  then do;
      servicenetbios_dgm = 1;
   end;
   else if _dm11 = 'PRINTER'  then do;
      serviceprinter = 1;
   end;
   else if _dm11 = 'SSH'  then do;
      servicessh = 1;
   end;
   else if _dm11 = 'UUCP'  then do;
      serviceuucp = 1;
   end;
   else if _dm11 = 'UUCP_PATH'  then do;
      serviceuucp_path = 1;
   end;
   else if _dm11 = 'MTP'  then do;
      servicemtp = 1;
   end;
   else if _dm11 = 'HTTP_443'  then do;
      servicehttp_443 = 1;
   end;
   else if _dm11 = 'NETBIOS_SSN'  then do;
      servicenetbios_ssn = 1;
   end;
   else if _dm11 = 'NETBIOS_NS'  then do;
      servicenetbios_ns = 1;
   end;
   else if _dm11 = 'HOSTNAMES'  then do;
      servicehostnames = 1;
   end;
   else if _dm11 = 'KSHELL'  then do;
      servicekshell = 1;
   end;
   else if _dm11 = 'NETSTAT'  then do;
      servicenetstat = 1;
   end;
   else if _dm11 = 'NAME'  then do;
      servicename = 1;
   end;
   else if _dm11 = 'SUPDUP'  then do;
      servicesupdup = 1;
   end;
   else if _dm11 = 'Z39_50'  then do;
      serviceZ39_50 = 1;
   end;
   else if _dm11 = 'URH_I'  then do;
      serviceurh_i = 1;
   end;
   else if _dm11 = 'IRC'  then do;
      serviceIRC = 1;
   end;
   else if _dm11 = 'X11'  then do;
      serviceX11 = 1;
   end;
   else if _dm11 = 'RED_I'  then do;
      servicered_i = 1;
   end;
   else if _dm11 = 'TFTP_U'  then do;
      servicetftp_u = 1;
   end;
   else do;
      serviceIRC = .;
      serviceX11 = .;
      serviceZ39_50 = .;
      serviceauth = .;
      servicebgp = .;
      servicecourier = .;
      servicecsnet_ns = .;
      servicectf = .;
      servicedaytime = .;
      servicediscard = .;
      servicedomain = .;
      servicedomain_u = .;
      serviceecho = .;
      serviceeco_i = .;
      serviceecr_i = .;
      serviceefs = .;
      serviceexec = .;
      servicefinger = .;
      serviceftp = .;
      serviceftp_data = .;
      servicegopher = .;
      servicehostnames = .;
      servicehttp = .;
      servicehttp_443 = .;
      serviceimap4 = .;
      serviceiso_tsap = .;
      serviceklogin = .;
      servicekshell = .;
      serviceldap = .;
      servicelink = .;
      servicelogin = .;
      servicemtp = .;
      servicename = .;
      servicenetbios_dgm = .;
      servicenetbios_ns = .;
      servicenetbios_ssn = .;
      servicenetstat = .;
      servicennsp = .;
      servicenntp = .;
      servicentp_u = .;
      serviceother = .;
      servicepop_2 = .;
      servicepop_3 = .;
      serviceprinter = .;
      serviceprivate = .;
      servicered_i = .;
      serviceremote_job = .;
      servicerje = .;
      serviceshell = .;
      servicesmtp = .;
      servicesql_net = .;
      servicessh = .;
      servicesunrpc = .;
      servicesupdup = .;
      servicesystat = .;
      servicetelnet = .;
      servicetftp_u = .;
      servicetime = .;
      serviceurh_i = .;
      serviceurp_i = .;
      serviceuucp = .;
      serviceuucp_path = .;
      servicevmnet = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** *************************;
*** Checking missing input Interval
*** *************************;

IF NMISS(
   count ,
   dst_host_diff_srv_rate ,
   dst_host_same_src_port_rate ,
   dst_host_serror_rate ,
   srv_serror_rate   ) THEN DO;
   SUBSTR(_WARN_, 1, 1) = 'M';

   _DM_BAD = 1;
END;
*** *************************;
*** Writing the Node intvl ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   S_count  =    -1.94654883066863 +     0.00516993790786 * count ;
   S_dst_host_diff_srv_rate  =    -0.52807939727467 +     36.9355309464653 *
        dst_host_diff_srv_rate ;
   S_dst_host_same_src_port_rate
          =    -1.42529724939459 +     2.13412773359463 *
        dst_host_same_src_port_rate ;
   S_dst_host_serror_rate  =    -0.50467607319002 +      2.4877890742109 *
        dst_host_serror_rate ;
   S_srv_serror_rate  =    -0.50461610695164 +     2.48793990142342 *
        srv_serror_rate ;
END;
ELSE DO;
   IF MISSING( count ) THEN S_count  = . ;
   ELSE S_count  =    -1.94654883066863 +     0.00516993790786 * count ;
   IF MISSING( dst_host_diff_srv_rate ) THEN S_dst_host_diff_srv_rate  = . ;
   ELSE S_dst_host_diff_srv_rate
          =    -0.52807939727467 +     36.9355309464653 *
        dst_host_diff_srv_rate ;
   IF MISSING( dst_host_same_src_port_rate ) THEN
        S_dst_host_same_src_port_rate  = . ;
   ELSE S_dst_host_same_src_port_rate
          =    -1.42529724939459 +     2.13412773359463 *
        dst_host_same_src_port_rate ;
   IF MISSING( dst_host_serror_rate ) THEN S_dst_host_serror_rate  = . ;
   ELSE S_dst_host_serror_rate
          =    -0.50467607319002 +      2.4877890742109 * dst_host_serror_rate
         ;
   IF MISSING( srv_serror_rate ) THEN S_srv_serror_rate  = . ;
   ELSE S_srv_serror_rate  =    -0.50461610695164 +     2.48793990142342 *
        srv_serror_rate ;
END;
*** *************************;
*** Writing the Node bin ;
*** *************************;
*** *************************;
*** Writing the Node nom ;
*** *************************;
*** *************************;
*** Writing the Node H1 ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   H11  =     1.39419812828416 * S_count  +    -0.00351395957549 *
        S_dst_host_diff_srv_rate  +     0.44217043913844 *
        S_dst_host_same_src_port_rate  +     0.78750704966898 *
        S_dst_host_serror_rate  +     0.82285408939854 * S_srv_serror_rate ;
   H12  =     0.21911770069361 * S_count  +    -0.15124236905718 *
        S_dst_host_diff_srv_rate  +     0.05873815340796 *
        S_dst_host_same_src_port_rate  +     0.09883347957362 *
        S_dst_host_serror_rate  +      0.0518812309779 * S_srv_serror_rate ;
   H13  =    -1.27282261425397 * S_count  +    -0.03637470539647 *
        S_dst_host_diff_srv_rate  +     -0.1793302840233 *
        S_dst_host_same_src_port_rate  +     0.00835168852936 *
        S_dst_host_serror_rate  +    -0.18940388150932 * S_srv_serror_rate ;
   H11  = H11  +     1.43081584432341 * logged_in0 ;
   H12  = H12  +     0.02984713091606 * logged_in0 ;
   H13  = H13  +    -0.17010022929623 * logged_in0 ;
   H11  = H11  +     1.23841795452729 * protocolicmp
          +     0.30714286474265 * protocoltcp  +     0.02142732391304 *
        serviceIRC  +     0.07322421862461 * serviceX11
          +    -0.12203940802615 * serviceZ39_50  +     0.05782240681439 *
        serviceauth  +     0.17494935609146 * servicebgp
          +     0.21879966846069 * servicecourier  +    -0.13370437947447 *
        servicecsnet_ns  +    -0.18422776044824 * servicectf
          +    -0.16304056575031 * servicedaytime  +    -0.13164254150312 *
        servicediscard  +     0.04371332090586 * servicedomain
          +    -0.16629454710435 * servicedomain_u  +     0.06024551516141 *
        serviceecho  +    -0.23912152870098 * serviceeco_i
          +     0.99162746978591 * serviceecr_i  +    -0.09138995014703 *
        serviceefs  +    -0.09311467763148 * serviceexec
          +    -0.06228947746575 * servicefinger  +    -0.06166122557598 *
        serviceftp  +    -0.13518244617304 * serviceftp_data
          +    -0.12270369664173 * servicegopher  +      0.0687577992892 *
        servicehostnames  +    -0.46011653055223 * servicehttp
          +     0.19188761695407 * servicehttp_443  +     0.04799333200617 *
        serviceimap4  +    -0.16946178159304 * serviceiso_tsap
          +    -0.04236997693192 * serviceklogin  +     0.24282737065873 *
        servicekshell  +     0.03534028203185 * serviceldap
          +    -0.17854342775928 * servicelink  +    -0.19998503675653 *
        servicelogin  +     0.07264650115376 * servicemtp
          +    -0.05672196380901 * servicename  +    -0.28798134199931 *
        servicenetbios_dgm  +     0.03648940080464 * servicenetbios_ns
          +     0.02318759926666 * servicenetbios_ssn
          +    -0.12205696637987 * servicenetstat  +    -0.13990181403979 *
        servicennsp  +    -0.02198485576932 * servicenntp
          +     0.16564580394975 * servicentp_u  +    -0.25974863030859 *
        serviceother  +     0.04739143672087 * servicepop_2
          +     0.15459152956294 * servicepop_3  +     0.09550677452998 *
        serviceprinter  +     0.22466869107872 * serviceprivate
          +     0.02867655758766 * servicered_i  +     0.12375706000979 *
        serviceremote_job  +    -0.09424963550517 * servicerje
          +     0.18253392313021 * serviceshell  +    -0.13268564849113 *
        servicesmtp  +    -0.00814804858269 * servicesql_net
          +     -0.0558534013408 * servicessh  +    -0.00952785655678 *
        servicesunrpc  +     0.12539601587821 * servicesupdup
          +      0.0393390625768 * servicesystat  +     0.08259134197727 *
        servicetelnet  +    -0.20840617798428 * servicetftp_u
          +     -0.1069733235046 * servicetime  +     0.08756782155232 *
        serviceurh_i  +     0.00556471422065 * serviceurp_i
          +    -0.04719082381833 * serviceuucp  +    -0.07586190251677 *
        serviceuucp_path  +     0.06974950654934 * servicevmnet ;
   H12  = H12  +    -0.03323238073324 * protocolicmp
          +    -0.05866602441006 * protocoltcp  +    -0.20816332566876 *
        serviceIRC  +    -0.13002993590791 * serviceX11
          +    -0.04426029219527 * serviceZ39_50  +      0.0764353664887 *
        serviceauth  +     0.12623806040303 * servicebgp
          +     0.07464796204153 * servicecourier  +     0.02407683955718 *
        servicecsnet_ns  +    -0.15168778798046 * servicectf
          +      0.0421834660003 * servicedaytime  +    -0.02760571998321 *
        servicediscard  +    -0.01046345623698 * servicedomain
          +     0.11938859415886 * servicedomain_u  +    -0.04648008291588 *
        serviceecho  +     0.21661368951816 * serviceeco_i
          +     0.14246171791117 * serviceecr_i  +     0.05998702710106 *
        serviceefs  +    -0.03748779671734 * serviceexec
          +    -0.07060419480569 * servicefinger  +    -0.05480193482689 *
        serviceftp  +     0.07605552133238 * serviceftp_data
          +     0.27245421912389 * servicegopher  +     0.12507525754748 *
        servicehostnames  +    -0.07904851274667 * servicehttp
          +    -0.09075849142842 * servicehttp_443  +     0.14498123088525 *
        serviceimap4  +     -0.1970408392361 * serviceiso_tsap
          +    -0.19517429292125 * serviceklogin  +    -0.09972777855399 *
        servicekshell  +    -0.10925335752202 * serviceldap
          +    -0.08435720397883 * servicelink  +     0.09182179828603 *
        servicelogin  +     0.07520127788424 * servicemtp
          +     0.20145793034791 * servicename  +     0.04193383025818 *
        servicenetbios_dgm  +      0.0396117868444 * servicenetbios_ns
          +    -0.03361040113552 * servicenetbios_ssn
          +     0.14435450299254 * servicenetstat  +     0.11170742187037 *
        servicennsp  +     0.00526075854846 * servicenntp
          +      0.0807641105696 * servicentp_u  +      0.0685310852207 *
        serviceother  +     -0.0123536686864 * servicepop_2
          +     0.15567532445447 * servicepop_3  +     0.04199289029797 *
        serviceprinter  +    -0.11925195646271 * serviceprivate
          +    -0.05133490886506 * servicered_i  +       -0.08529337077 *
        serviceremote_job  +     -0.0783287944482 * servicerje
          +    -0.18029471844779 * serviceshell  +     0.02781055489145 *
        servicesmtp  +    -0.00837992064082 * servicesql_net
          +     0.01457059105607 * servicessh  +     0.04418732995484 *
        servicesunrpc  +     0.12057942145381 * servicesupdup
          +     0.14624938412013 * servicesystat  +     0.10025526062038 *
        servicetelnet  +    -0.00541640932249 * servicetftp_u
          +    -0.05283582721708 * servicetime  +     0.11891969576828 *
        serviceurh_i  +    -0.01271792628825 * serviceurp_i
          +    -0.01103131722827 * serviceuucp  +     0.04085922650329 *
        serviceuucp_path  +    -0.08125790077598 * servicevmnet ;
   H13  = H13  +    -0.56272790862233 * protocolicmp
          +    -0.25891474340761 * protocoltcp  +    -0.21807719645627 *
        serviceIRC  +    -0.34739514271854 * serviceX11
          +    -0.23156226862654 * serviceZ39_50  +     0.08468968187002 *
        serviceauth  +     -0.0844204764973 * servicebgp
          +     0.06200683479338 * servicecourier  +     0.03720099946635 *
        servicecsnet_ns  +     0.16481621178439 * servicectf
          +    -0.23992557784525 * servicedaytime  +     -0.1299753944491 *
        servicediscard  +    -0.14555364323706 * servicedomain
          +    -0.15534846056667 * servicedomain_u  +    -0.34512293870116 *
        serviceecho  +     0.13389377058751 * serviceeco_i
          +    -0.22343560130574 * serviceecr_i  +    -0.06527592428258 *
        serviceefs  +     0.06513018953844 * serviceexec
          +    -0.04833802974844 * servicefinger  +     0.00806552992078 *
        serviceftp  +    -0.23649681075532 * serviceftp_data
          +    -0.13276626717741 * servicegopher  +     -0.0210642343209 *
        servicehostnames  +       0.077712587195 * servicehttp
          +     0.11055560799042 * servicehttp_443  +     -0.0962051871193 *
        serviceimap4  +    -0.02027100494665 * serviceiso_tsap
          +    -0.11672425776042 * serviceklogin  +     0.07563253784001 *
        servicekshell  +    -0.05701963918658 * serviceldap
          +    -0.12821964944809 * servicelink  +     0.12279052007328 *
        servicelogin  +     0.13144430629247 * servicemtp
          +     0.03192496643507 * servicename  +     0.09068152680451 *
        servicenetbios_dgm  +     0.00201986429076 * servicenetbios_ns
          +     0.04341443099617 * servicenetbios_ssn
          +    -0.04461951755351 * servicenetstat  +     0.10869420694271 *
        servicennsp  +     0.11027327294846 * servicenntp
          +    -0.05618100939721 * servicentp_u  +      0.1332704734024 *
        serviceother  +     0.19036815394803 * servicepop_2
          +    -0.20831874526355 * servicepop_3  +     0.12382408321435 *
        serviceprinter  +    -0.14053148505488 * serviceprivate
          +     0.06416964279708 * servicered_i  +    -0.07460330527152 *
        serviceremote_job  +     0.16163094346299 * servicerje
          +    -0.00409236549145 * serviceshell  +     0.02598429723085 *
        servicesmtp  +    -0.03066731072421 * servicesql_net
          +     0.01281732960741 * servicessh  +    -0.11213646958184 *
        servicesunrpc  +    -0.06214669302988 * servicesupdup
          +    -0.09438234217355 * servicesystat  +    -0.09422023598297 *
        servicetelnet  +     0.02389124376616 * servicetftp_u
          +    -0.05108089306524 * servicetime  +     0.03734276637176 *
        serviceurh_i  +    -0.14618224160834 * serviceurp_i
          +    -0.10668346245351 * serviceuucp  +     0.13739891574414 *
        serviceuucp_path  +     0.04526956984399 * servicevmnet ;
   H11  =      0.8415816855171 + H11 ;
   H12  =    -2.16608595208926 + H12 ;
   H13  =     1.03268203744669 + H13 ;
   H11  = TANH(H11 );
   H12  = TANH(H12 );
   H13  = TANH(H13 );
END;
ELSE DO;
   H11  = .;
   H12  = .;
   H13  = .;
END;
*** *************************;
*** Writing the Node attack_type ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   P_attack_typenorm  =    -121.580617657674 * H11  +    -27.2859287867491 *
        H12  +      83.390454009074 * H13 ;
   P_attack_typenorm  =    -2.05287223803262 + P_attack_typenorm ;
   P_attack_typedos  = 0;
   _MAX_ = MAX (P_attack_typenorm , P_attack_typedos );
   _SUM_ = 0.;
   P_attack_typenorm  = EXP(P_attack_typenorm  - _MAX_);
   _SUM_ = _SUM_ + P_attack_typenorm ;
   P_attack_typedos  = EXP(P_attack_typedos  - _MAX_);
   _SUM_ = _SUM_ + P_attack_typedos ;
   P_attack_typenorm  = P_attack_typenorm  / _SUM_;
   P_attack_typedos  = P_attack_typedos  / _SUM_;
END;
ELSE DO;
   P_attack_typenorm  = .;
   P_attack_typedos  = .;
END;
IF _DM_BAD EQ 1 THEN DO;
   P_attack_typenorm  =     0.13403618518618;
   P_attack_typedos  =     0.86596381481381;
END;
*** *************************;
*** Writing the I_attack_type  AND U_attack_type ;
*** *************************;
_MAXP_ = P_attack_typenorm ;
I_attack_type  = "NORM " ;
U_attack_type  = "norm " ;
IF( _MAXP_ LT P_attack_typedos  ) THEN DO;
   _MAXP_ = P_attack_typedos ;
   I_attack_type  = "DOS  " ;
   U_attack_type  = "dos  " ;
END;
********************************;
*** End Scoring Code for Neural;
********************************;
drop
H11
H12
H13
;
drop S_:;

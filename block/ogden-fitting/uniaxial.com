from driverConstants import *
from driverStandard import StandardAnalysis
import driverUtils, sys
options = {
    'SIMExt':'.sim',
    'abaquslm_license_file':'27000@abaqusres.lic.uct.ac.za',
    'academic':RESEARCH,
    'ams':OFF,
    'analysisType':STANDARD,
    'applicationName':'analysis',
    'aqua':OFF,
    'beamSectGen':OFF,
    'biorid':OFF,
    'cavityTypes':[],
    'cavparallel':OFF,
    'compile_cpp':['g++', '-c', '-fPIC', '-w', '-Wno-deprecated', '-DTYPENAME=typename', '-D_LINUX_SOURCE', '-DABQ_LINUX', '-DABQ_LNX86_64', '-DSMA_GNUC', '-DFOR_TRAIL', '-DHAS_BOOL', '-DASSERT_ENABLED', '-D_BSD_TYPES', '-D_BSD_SOURCE', '-D_GNU_SOURCE', '-D_POSIX_SOURCE', '-D_XOPEN_SOURCE_EXTENDED', '-D_XOPEN_SOURCE', '-DHAVE_OPENGL', '-DHKS_OPEN_GL', '-DGL_GLEXT_PROTOTYPES', '-DMULTI_THREADING_ENABLED', '-D_REENTRANT', '-DABQ_MPI_SUPPORT', '-DBIT64', '-D_LARGEFILE64_SOURCE', '-D_FILE_OFFSET_BITS=64', '-DABQ_MPI_PMPI', '-I%I'],
    'compile_fmu':['g++', '-c', '-fPIC', '-I%I'],
    'compile_fortran':'gfortran -c -fPIC -I%I -ffree-form -ffree-line-length-none',
    'complexFrequency':OFF,
    'contact':OFF,
    'cosimulation':OFF,
    'coupledProcedure':OFF,
    'cpus':1,
    'cse':OFF,
    'cyclicSymmetryModel':OFF,
    'directCyclic':OFF,
    'direct_solver':DMP,
    'doc_root':'http://localhost:2080/v6.14',
    'doc_root_type':'html',
    'dsa':OFF,
    'dynamic':OFF,
    'filPrt':[],
    'fils':[],
    'finitesliding':OFF,
    'foundation':OFF,
    'geostatic':OFF,
    'geotech':OFF,
    'heatTransfer':OFF,
    'importer':OFF,
    'importerParts':OFF,
    'includes':[],
    'initialConditionsFile':OFF,
    'input':'uniaxial',
    'inputFormat':INP,
    'job':'uniaxial',
    'keyword_licenses':[],
    'lanczos':OFF,
    'libs':[],
    'license_server_type':FLEXNET,
    'link_exe':['g++', '-fPIC', '-Wl,-Bdynamic', '-o', '%J', '%F', '%M', '%L', '%B', '%O', '-lpthread', '-lm', '-lifcoremt'],
    'link_fmu':['g++', '-fPIC', '-shared', '-o', '%J', '%M'],
    'link_sl':'gfortran -fPIC -shared %E -Wl,-soname,%U -o %U %F %A %L %B -Wl,-Bdynamic  -lifport -lifcoremt',
    'magnetostatic':OFF,
    'massDiffusion':OFF,
    'modifiedTet':OFF,
    'moldflowFiles':[],
    'moldflowMaterial':OFF,
    'mp_environment_export':('MPI_PROPAGATE_TSTP', 'ABA_CM_BUFFERING', 'ABA_CM_BUFFERING_LIMIT', 'ABA_ITERATIVE_SOLVER_VERBOSE', 'ABA_DMPSOLVER_BWDPARALLELOFF', 'ABA_ELP_SURFACE_SPLIT', 'ABA_ELP_SUSPEND', 'ABA_HOME', 'ABA_MEMORY_MODE', 'ABA_MPI_MESSAGE_TRACKING', 'ABA_MPI_VERBOSE_LEVEL', 'ABA_PATH', 'ABAQUS_CSE_RELTIMETOLERANCE', 'ABA_RESOURCE_MONITOR', 'ABA_RESOURCE_USEMALLINFO', 'ABAQUS_LANG', 'ABAQUS_CSE_CURRCONFIGMAPPING', 'ABAQUS_MPF_DIAGNOSTIC_LEVEL', 'ABAQUSLM_LICENSE_FILE', 'ABQ_CRTMALLOC', 'ABQ_DATACHECK', 'ABQ_RECOVER', 'ABQ_RESTART', 'ABQ_SPLITFILE', 'ABQ_XPL_WINDOWDUMP', 'ABQ_XPL_PARTITIONSIZE', 'ABQLMHANGLIMIT', 'ABQLMQUEUE', 'ABQLMUSER', 'CCI_RENDEZVOUS', 'DOMAIN', 'DOMAIN_CPUS', 'DOUBLE_PRECISION', 'FLEXLM_DIAGNOSTICS', 'FOR0006', 'FOR0064', 'FOR_IGNORE_EXCEPTIONS', 'FOR_DISABLE_DIAGNOSTIC_DISPLAY', 'LD_PRELOAD', 'MP_NUMBER_OF_THREADS', 'MPC_GANG', 'MPI_FLAGS', 'MPI_FLUSH_FCACHE', 'MPI_RDMA_NENVELOPE', 'MPI_SOCKBUFSIZE', 'MPI_USE_MALLOPT_MMAP_MAX', 'MPI_USE_MALLOPT_MMAP_THRESHOLD', 'MPI_USE_MALLOPT_SBRK_PROTECTION', 'MPI_WORKDIR', 'MPCCI_DEBUG', 'MPCCI_CODEID', 'MPCCI_JOBID', 'MPCCI_NETDEVICE', 'MPCCI_TINFO', 'MPCCI_SERVER', 'MPIEXEC_AFFINITY_TABLE', 'ABAQUS_CCI_DEBUG', 'NCPUS', 'OMP_DYNAMIC', 'OMP_NUM_THREADS', 'OUTDIR', 'PAIDUP', 'PARALLEL_METHOD', 'RAIDEV_NDREG_LAZYMEM', 'ABA_SYMBOLIC_GENERALCOLLAPSE', 'ABA_SYMBOLIC_GENERAL_MAXCLIQUERANK', 'ABA_ADM_MINIMUMINCREASE', 'ABA_ADM_MINIMUMDECREASE', 'IPATH_NO_CPUAFFINITY', 'MALLOC_MMAP_THRESHOLD_', 'ABA_EXT_SIMOUTPUT', 'SMA_WS', 'SMA_PARENT', 'SMA_PLATFORM', 'ABA_PRE_DECOMPOSITION', 'ACML_FAST_MALLOC', 'ACML_FAST_MALLOC_CHUNK_SIZE', 'ACML_FAST_MALLOC_MAX_CHUNKS', 'ACML_FAST_MALLOC_DEBUG', 'MKL_NUM_THREADS', 'MKL_DYNAMIC'),
    'mp_file_system':(DETECT, DETECT),
    'mp_mode':THREADS,
    'mp_mode_requested':MPI,
    'mp_mpi_implementation':PMPI,
    'mp_mpirun_path':{PMPI: '/opt/Abaqus/6.14-1/code/bin/SMAExternal/pmpi-9.1.2/bin/mpirun'},
    'mp_num_parallel_ftps':(4, 4),
    'mp_rsh_command':'ssh -n -l %U %H %C',
    'multiphysics':OFF,
    'noDmpDirect':[],
    'noMultiHost':[],
    'noMultiHostElemLoop':[],
    'no_domain_check':1,
    'onCaeGraphicsStartup':driverUtils.decodeFunction('begin 666 -\nM8P     H    1P   $,   !SLQ   \'0  &H! &H" \'T  \'0  &H! &H# \'T!\nM \'0  &H! &H$ \'T" \'0  &H! &H% \'T# \'0  &H! &H& \'T$ \'0\' \'T% \'0(\nM \'T& \'0( \'T\' \'0( \'T( \'0) \'0* \'0+ \'0, &8$ \'T) \'0- \'T* \'0. \'T+\nM \'0  &H/ &H0 \'T, \'0  &H/ &H1 \'T- \'0  &H/ &H2 \'T. \'0  &H/ &H3\nM \'T/ \'0( \'T0 \'0( \'T1 \'0( \'T2 &0! \'T3 \'0( \'T4 \'0  &H/ &H4 \'T5\nM \'0  &H/ &H5 \'T6 \'0  &H/ &H6 \'T7 \'0  &H/ &H7 \'T8 \'0  &H/ &H8\nM \'T9 \'0  &H/ &H9 \'T: \'0  &H/ &H: \'T; \'0  &H/ &H; \'T< &0" \'T=\nM &0" \'T> \'P# &0  &L" \'-0 7P# &0# &L" \'-0 7P# &0$ &L" \'+) 60%\nM \'T> \'0. \'T7 &0& \'T, &0\' \'T- \'P# &0  &L" \'(M GP$ &0" !ED  !K\nM P!R+0)\\! !D @ 99 @ :P$ <[0!? 0 9 ( &60) &L" \'+& 7P$ &0% !ED\nM!0!K  !RQ@%D!@!]# !D"@!]#0!QQ@%Q+0)N9 !\\ P!D"P!K @!RY %D# !]\nM# !D#0!]#0!N20!\\ P!D#@!K @!R+0)\\ 0!D#P!K @!R"P)D!@!]# !D$ !]\nM#0!Q+0)\\ 0!D$0 @9!( :P( <BT"9!, ?0P 9 T ?0T <2T";@  ?   9!0 \nM:P( <O4"= X ?1H ? $ 9!4 (&06 &L" \')D G0. \'T0 &07 \'T, &08 \'T-\nM \'$Z#GP! &09 &L" \'*. GP> \')_ G0. \'T6 \'\'R F0: \'T, &0\' \'T- \'$Z\nM#GP! &0; &L" \'*^ F0< \'T, &0= \'T- \'0. \'T0 \'0) \'0* \'0, &8# \'T)\nM \'$Z#GP! &0> "!D\'P!K @!R.@YD( !]# !D(0!]#0!T#@!]$ !T"0!T"@!T\nM# !F P!]"0!Q.@YN10M\\  !D(@ @9", :P( <N@\'9"0 9"4 ;!T ;1X ?1\\ \nM;1\\ ?2   7P> \'(J W0. \'T7 &X& &0& \'T, \'0. \'T1 &0F \'T3 \'P" &0"\nM !ED)P!K! !S; -\\ @!D @ 99"< :P( <@X%? ( 9 4 &60% &L% \'(.!60D\nM &0  &P@ \'TA \'PA &HA \'P" &0G !ED* "# @!](@!T(@!\\(@"# 0!D!0!K\nM!0!R#@5Y%P!\\(0!J(P!\\(@!D @ 9@P$ ?2, 5VX-  $! 60I \'TC &X! %A\\\nM(P!D*@!K  !RX -\\(P!D*P 4?2, ;@  ?", 9"P :P4 <@L%?!X <A8$? $ \nM9"T :P( <PT$?!\\ 9"X ? $ @P( <A8$9"< ?1P ;AD 9"0 9   ;"0 ?20 \nM9"\\ ?"0 :B4 9#  /\'PC &03 &L% \'((!70. \'T0 \'PC &0Q &L% \')N!\'PC\nM &0R &L  \')N!\'P< &0B &L$ \')N!&0B \'T< &XJ \'PC &0R &L$ \'*8!\'0(\nM \'T0 \'PC &0& &L$ \'*8!&0) \'T< \'&8!&X  \'P> \'(%!7E" &0D &0  &PF\nM \'TE \'PE &HG (,  &0" !ED)P @9#, :P( <M\\$= X ?1@ = H = L = P \nM9@, ?0D ;@  5W$"!0$! 70. \'T8 \'0* \'0+ \'0, &8# \'T) \'$"!5AQ!05Q\nM" 5Q"P5Q#@5N  !\\\'P!D- !\\ 0!\\( "# P!R-05T#@!]&@!D @!])@!T#@!]\nM& !N  !\\\'P!D-0!\\ 0!\\( "# P!S605\\\'P!D-@!\\ 0!\\( "# P!RS@9T#@!]\nM" !\\\'P!D-P!\\ 0"# @!S?05\\\'P!D. !\\ 0"# @!R"@9T" !]" !T#@!]&@!\\\nM\'P!D.0!\\ 0"# @!RIP5D.@!]# !D#0!]#0!Q)09\\\'P!D.P!\\ 0"# @!ROP5D\nM& !]# !Q)09\\\'P!D/ !\\ 0"# @!RUP5T#@!]$@!Q)09\\\'P!D+@!\\ 0"# @!R\nM[P5T#@!]$@!Q)09\\\'P!D/0!\\ 0"# @!R)09T#@!]$ !Q)09N&P!\\\'P!D-@!\\\nM 0!\\( "# P!R)09D)P!]\' !N  !\\\'P!D/@!\\ 0!\\( "# P!RS@9T#@!]" !T\nM#@!]$ !\\\'P!D/P!\\ 0!\\( "# P!R7@9T" !]" !QRP9\\\'P!D0 !\\ 0"# @!R\nMRP9T" !]$ !\\\'P!D00!\\ 0"# @!RG@9D) !D  !L) !]) !D0@!\\) !J)0!D\nM0P \\;@  ?!\\ 9$0 ? $ @P( <L@&= X ?1@ = H = L = P 9@, ?0D <<@&\nM<<L&<<X&;@  ?!\\ 9$4 ? $ @P( <J,\'?!\\ 9$8 ? $ @P( <B@\'?!X <AD\'\nM? ( 9+X :P( <B4\'= X ?1@ = L = H = P 9@, ?0D <24\'<: \'9#H ?0P \nM9 T ?0T <>4\'?!\\ 9$@ ? $ @P( <T8\'?!\\ 9$D ? $ @P( <H(\'?!X <J \'\nM?!@ = X :P, <FT\'= D = L = H = P 9@0 ?0D <7\\\'= L = H = P 9@, \nM?0D <: \'<>4\'?!\\ 9$H ? $ @P( <N4\'9 8 ?0P 9 T ?0T <>4\'<3H.?!\\ \nM9$L ? $ @P( <LH\'= X ?1@ = H = L = P 9@, ?0D <3H.? $ 9$P :P( \nM<CH.9 < ?0P 9$T ?0T <3H.;E(&?   9$X :P( <@P(? $ 9$\\ :P( <CH.\nM9%  ?0P <3H.;BX&?   9%$ :P( <CP(? $ 9%( :P( <CH.= X ?1  9#H \nM?0P 9#H ?0T <3H.;OX%?   9%, :P( <H$(? $ 9%0 :P( <F,(9 8 ?0P \nM9%4 ?0T <3H.? $ 9%8 :P( <CH.9%< ?0P 9%@ ?0T <3H.;KD%?   9%D \nM:P( <@@)? $ 9%H :P( <J@(9%L ?0P 9%P ?0T <3H.? $ 9%T :P( <LD(\nM9%X ?0P 9#H ?0T = X ?10 <3H.? $ 9%\\ :P( <NH(9 8 ?0P 9 T ?0T \nM= X ?1( <3H.? $ 9&  :P( <CH.= X ?1@ = H ?0D <3H.;C(%?   9&$ \nM:P( <ID)= X ?1L = D = L = H = P 9@0 ?0D ? $ 9&( :P( <D<)= X \nM?0@ = X ?1H <3H.? $ 9&, :P( <FX)= D = H = L = P 9@0 ?0D = X \nM?1$ <3H.? $ 9&0 &61E &L" \'(Z#G0* \'0+ \'0, &8# \'T) \'0. \'T6 \'$Z\nM#FZA!\'P  &1F &L" \'+!"7P! &01 "!D9P!K @!R.@YT#@!]%P!Q.@YN>01\\\nM  !D: !K @!R)0U\\\'@!S[PED) !D  !L) !]) !D:0!\\) !J)0!D:@ \\;@  \nM? , 9&@ :P( <@<+= X ?1< ? $ 9&L (&1L &L" \'-1"GP! &1K "!D;0!K\nM @!S40I\\ 0!D%0 @9&X :P( <U$*? $ 9!4 (&1O &L" \'-1"GP! &05 "!D\nM< !K @!R6@ID!@!]# !QS M\\ 0!D:P @9\'$ :P( <G,*= X ?1H <<P+? $ \nM9&L (&1R &L" \'*,"F0B \'T< \'\',"WP! &1S "!D= !K @!RJPID=0!]# !D\nM30!]#0!QS M\\ 0!D=@ @9\'< :P( <NL*9 T ?0P 9 8 ?0T ? $ 9\'@ :P( \nM<@0+? ( 9+\\ :P( <@0+9\'H ?1T <00+<<P+? $ 9\'8 (&1[ &L" \'+,"W0.\nM \'T: \'\',"V[% \'P> \'+,"WP! &1\\ "!D?0!K @!S/0M\\ 0!D?@ @9\'\\ :P( \nM<ST+? $ 9\'X (&2  &L" \'+,"W0. \'T7 \'P! &1K "!D; !K @!R7 MD#0!]\nM# !QR0M\\ 0!D:P @9($ :P( <G4+= X ?1H <<D+? $ 9&L (&2" &L" \'*4\nM"V0B \'T< &0A \'T, \'\')"WP! &1K "!D<@!K @!RK0MD(@!]\' !QR0M\\ 0!D\nM<P @9\'0 :P( <LD+= X ?1  <<D+<<P+;@  ? $ 9!4 (&1O &L" \'(*#&0D\nM &0  &PF \'TE \'PE &HG (,  &0" !ED@P!K @!R(@UD!@!]# !Q(@UQ.@Y\\\nM 0!DA  @9(4 :P( <B,,9"( ?1P <3H.? $ 9"L (&2& &L" \')(#\'0. \'T7\nM \'0. \'T; &0G \'T< \'$Z#GP! &1S "!DAP!K @!RQPQ\\\'@!RK QT"P!T"@!T\nM# !F P!]"0!D!@!]# !D.@!]#0!\\ @!DP !K @!RQ QD!@!]#0!\\ 0!DB !K\nM @!RH QT#@!]$0!QJ0QT#@!]" !QQ QQ(@UD!@!]# !DB0!]#0!T#@!]$ !T\nM#@!]&@!Q.@Y\\ 0!DB@!K @!RX@QD!@!]# !D#0!]#0!Q.@Y\\ 0!DBP!K @!R\nM_0QD.@!]# !DC !]#0!Q.@Y\\ 0!D?  99(T :P( <CH.9 8 ?0P 9%@ ?0T \nM= X ?1< <3H.;A4!?   9 L :P( <H,-? $ 9!$ (&2. &L" \')6#60& \'T,\nM &18 \'T- \'0. \'T2 \'$Z#GP! &2/ &L" \')K#60& \'T, \'$Z#GP! &20 &L"\nM \'(Z#G0. \'T2 \'$Z#FZW \'P  &21 &L" \'*\\#70. \'T0 \'P! &22 &L" \'(Z\nM#G0. \'T8 \'0* \'0+ \'0, &8# \'T) \'$Z#FY^ \'P  &23 &L" \'(Z#GP! &24\nM &L" \'/@#7P! &25 &L" \'(Z#GP" &3! &L" \'+U#627 \'T, &XS &0D &0 \nM &PH \'TG \'PG &HI (,  &28 &L" \'(B#G0. \'T( &29 \'T, &X& &2: \'T,\nM &2; \'T- \'0. \'T7 \'$Z#FX  \'P! &0( "!DG !K @!R1 ]T"P!T"@!T# !F\nM P!]"0!D) !D  !L) !]) !\\) !J)0!J*@!DG0"# 0!S@ YT#@!]&P!N  !\\\nM @!D @ 99 4 :P( <D0/? ( 9 4 &60) &L  \')$#V0O \'PD &HE &2> #Q\\\nM 0!DGP!K @!R00]\\  !DH !K @!R&@]\\ @!D @ 99 4 :P( <CL/? ( 9 4 \nM&60G &L" \'([#WP" &0G !ED<P @9*$ :P( <CL/= H = L = P 9@, ?0D \nM9 8 ?0P = X ?1H <3L/<3X/?   9*( :P( <CX/9#H ?0P 9*, ?0T = X \nM?0@ <3X/<4$/<40/;@  ? , 9   :P( <M8/? $ 9 @ (&2< &L# \'+6#WP!\nM &2D &L" \')U#W0. \'T; &X  &0& \'T. &0\' \'T/ \'P$ &0" !ED  !K P!R\nMX@]\\! !D @ 99 @ :P$ <\\$/? 0 9 ( &60) &L" \'+3#WP$ &0% !ED!0!K\nM  !RTP]D!@!]# !D"@!]#0!QTP]QX@]N# !\\# !]#@!\\#0!]#P!T#@!\\$@!K\nM @!R]P]T#@!]% !N  !T#@!\\" !K @!R#!!T*P!]"@!N  !T  !J#P!J+ !D\nMI0!\\!0!DI@!\\!@!DIP!\\!P!DJ !\\" !DJ0!\\"0!DJ@!\\"@!DJP!\\"P!DK !\\\nM&P!DK0!\\\' !DK@!\\# !DKP!\\#0!DL !\\#@!DL0!\\#P!DL@!\\$ !DLP!\\$0!D\nMM !\\$@!DM0!\\% !DM@!\\$P!DMP!\\%0!DN !\\%@!DN0!\\%P!DN@!\\& !DNP!\\\nM&0!DO !\\&@!DO0!\\\'0"# !D!9   4RC"    3F?Q:..(M?C4/FD     <Q\\ \nM  !(=6UM:6YG8FER9"!#;VUM=6YI8V%T:6]N<R!,=&0N<Q    !(=6UM:6YG\nM8FER9"!,=&0N:0$   !G        \\#]G        Z#]I!    &D%    9S$(\nMK!Q:9/L_= ,   !31TEG>Q2N1^%ZI#]G        ^#]T P   $E"37,.    \nM1UA4.# P(%1E>\'1U<F5GA>M1N!Z% 4!I!@   \'0&    1UA4.# P9]>C<#T*\nMU^L_= 8    S1&QA8G-I#0   \',-    5VEL9&-A="!64#@X,&<        6\nM0&>:F9F9F9GI/W0)    4$52345$24$S9S,S,S,S,\\,_<PL   !\'3$E.5"!2\nM,R!05&>:F9F9F9FI/V=F9F9F9F;F/VD9    <QD   !\'3$E.5"!2,R!05" K\nM($=,24Y4($=A;6UA9YJ9F9F9F=D_9P        ! :0,   !T P   $%426G_\nM____* (   !T!@   \'-E87)C:\'0*    24=.3U)%0T%316<M0QSKXC8*/VD"\nM    = $    @9P          9S,S,S,S,],_:0H   !G<1L-X"V0ZC]S$   \nM $%422!&:7)E1TP@5C<S,#!T!0   %8S-# P= $    Q=!<   !!0D%155-?\nM04Q,3U=?051)7U1204Y33&=Q/0K7HW#M/V=8.;3(=K[O/W0"    ,S)T"   \nM $U/0DE,2519= 0   !&:7)E= 8   !2861E;VYS"    $9I<F5\'3"!6= < \nM  !&:7)E4\')O= 4   !6-S$P,&<       #@/W0%    5C4Q,#!T!0   %8S\nM,C P= 4   !6.3@P,\'0(    36]B:6QI=\'ES%P   $UO8FEL:71Y(%)A9&5O\nM;B!(1" S-C4P<PD   !&:7)E1TP@5C5S#    $9I<F5\'3"!6-3(P,\'0!    \nM,\'06    04)!45537TE35DE37U1(4D532$],1\',,    1FER94=,(%8U-S P\nM<P@   !&:7)E($=,(\',*    1FER92!\'3"!4,G,%    +C0U,3ES"@   $9I\nM<F4@1TP@6#%S"@   $9I<F4@1TP@6C%S#    $9I<F4@1TP@.\'@P,\',+    \nM1FER92!\'3#@X,#!S%    %)!1T4@,3(X(%!R;R!X.#8O4U-%9S,S,S,S,_L_\nM= 8   !#;VUP87%S"    %!"6$=$+4%$9Q2N1^%Z%.X_<Q(   !$:6%M;VYD\nM($UU;\'1I;65D:6%S"    $9I<F4@1TPQ= 0   !%3%-!<PT   !%3%-!($52\nM05I/4B!89YJ9F9F9F>$_<P\\   !%3%-!(%-Y;F5R9WD@24EGN!Z%ZU&XSC]G\nM,S,S,S,SZS]S%P   $AE=VQE=\'0M4&%C:V%R9"!#;VUP86YY= <   !H<\'9I\nM<V9X9RE<C\\+U*.P_9\\W,S,S,S.P_= L   !L:6(S-6%C9&$S,&<*UZ-P/0KO\nM/W0+    ;&EB9&1V:7-X9VQS%0   %9I<G1U86P@365M;W)Y($1R:79E<G0%\nM    26YT96QS"P   $EN=&5L(#DT-4=-<PT   !);G1E;"!#86YT:6=A:2  \nM  !S(    $UO8FEL92!);G1E;"A2*2 T(%-E<FEE<R!%>\'!R97-S<Q8   !)\nM;G1E<F=R87!H($-O<G!O<F%T:6]N= 8   !W8V=D<G9S$@   $Y6241)02!#\nM;W)P;W)A=&EO;G0"    3TYT$@   $%"05%54U]$25-!0DQ%7T9016D.    \nM<PX   !1=6%D<F\\@1E@@-#8P,\',.    475A9\')O($98(#$W,#!S#0   %%U\nM861R;R!&6" U.#!S#0   %%U861R;R!&6" U-S!S#0   %%U861R;R!&6" S\nM-S!S#@   %%U861R;R!&6" S-3 P<PX   !1=6%D<F\\@1E@@.#@P36D+    \nM<PL   !1=6%D<F\\R(%!R;V<        $0&D/    <P\\   !1=6%D<F\\T(#<U\nM,"!81TQS&    %%U861R;S0@-S4P(%A\'3"]!1U O4U-%,G,/    +C$@3E9)\nM1$E!(#4S+C,V:34   !T!P   $=E1F]R8V5I"0   \',)    475A9\')O($98\nM:0<   !T!P   %%U861R;S1T!P   %%U861R;S)S#@   %%U861R;R!&6" Q\nM,S P<PX   !1=6%D<F\\@1E@@-3<P370%    -C1B:71I#    \',,    475A\nM9\')O(#$P,#!-<PH   !1=6%D<F\\@3E93<PL   !1=6%D<F\\R($U84G,4    \nM475A9\')O,B!-6%(O04=0+U-313)G9F9F9F9F_C]S$P   $=E1F]R8V4@,C4V\nM+U!#22]34T5S#@   %))5D$@5$Y4("A00TDI9X7K4;@>A?\\_<PD   !2259!\nM(%1.5#)T!@   $E-4$%#5\',)    4D53+U,O,2\\R<PH   !64%)/+T(O,3(X\nM<Q8   !3=6X@36EC<F]S>7-T96US+"!);F,N<PT   !85E(M,3(P,"P@5DE3\nM<PH   !"<FEA;B!0875L<P@   !-97-A(%@Q,7,.    365S82!/9F938W)E\nM96YS"@   $UE<V$@,RXT+C)G>Q2N1^%ZM#]T"    &QN>#@V7S8T9P      \nM $E 9P      @$% 9P       /(_= 0   !-97-A= P   !!0E%?44%?4%))\nM3E1T"P   $U%4T%?3D]?05--<Q$   !-97-A($=,6"!);F1I<F5C=\',<    \nM365S82!P<F]J96-T.B!W=W<N;65S83-D+F]R9W,+    *#$N-2!-97-A(#9S\nM%@   %9!($QI;G5X(%-Y<W1E;7,L($EN8RYG4K@>A>M1]#]S"P   $=$22!\'\nM96YE<FEC= X   !G<F%P:&EC<T1R:79E<G0/    9&]U8FQE0G5F9F5R:6YG\nM= \\   !B86-K9F%C94-U;&QI;F=T#    &1I<W!L87E,:7-T<W03    :&EG\nM:&QI9VAT365T:&]D2&EN=\'0(    9\')A9TUO9&5T$@   &%U=&]&:71!9G1E\nM<E)O=&%T970)    86YT:4%L:6%S=!    !T<F%N<VQU8V5N8WE-;V1E=!4 \nM  !P;VQY9V]N3V9F<V5T0V]N<W1A;G1T$@   \'!O;\'EG;VY/9F9S9713;&]P\nM970:    <\')I;G10;VQY9V]N3V9F<V5T0V]N<W1A;G1T%P   \'!R:6YT4&]L\nM>6=O;D]F9G-E=%-L;W!E= P   !V97)T97A!<G)A>7-T&@   \'9E<G1E>$%R\nM<F%Y<TEN1&ES<&QA>4QI<W1S= X   !T97AT=7)E36%P<&EN9W03    <\')I\nM;G1497AT=7)E36%P<&EN9W0<    8V]N=&]U<E)A;F=E5&5X=\'5R95!R96-I\nM<VEO;G0/    9&ER96-T4F5N9&5R:6YG=!0   !H87)D=V%R94%C8V5L97)A\nM=&EO;G03    86-C96QE<F%T94]F9E-C<F5E;G0/    :&%R9\'=A<F5/=F5R\nM;&%Y= \\   !B86-K9W)O=6YD0V]L;W)T#    &)A8VMI;F=3=&]R970)    \nM7W9I<W5A;$ED* ,   !I 0   &D%    <P4    N-#4Q.2@#    :0$   !I\nM!    \',/    +C$@3E9)1$E!(#4S+C,V* ,   !I 0   &D"    3B@#    \nM:0$   !I @   \',*    365S82 S+C0N,B@M    = <   !S97-S:6]N= P \nM  !G<F%P:&EC<TEN9F]T"    &=L5F5N9&]R= H   !G;%)E;F1E<F5R= D \nM  !G;%9E<G-I;VYT#P   &=L>%-E<G9E<E9E;F1O<G00    9VQX4V5R=F5R\nM5F5R<VEO;G0\'    3U!%3E]\'3%(?    =!    !(05)$5T%215]/5D523$%9\nM=!    !33T945T%215]/5D523$%9= ,   !83U)T!0   $),14Y$= 4   !!\nM4U])4W0#    3T9&=!8   !D969A=6QT1W)A<&AI8W-/<\'1I;VYS4C,   !2\nM-    %(U    4C8   !2/    %(]    4CX   !2/P   %)     4D$   !2\nM,0   %(R    = 0   !.;VYE= (   !R95(&    4@<   !T!@   \'-T<FEN\nM9W0%    <W!L:71T P   &QE;G0$    871O9G0"    ;W-T!P   &5N=FER\nM;VYT"    \'!L871F;W)M= P   !A<F-H:71E8W1U<F5T P   \'5T:70+    \nM9V5T4&QA=&9O<FUT!P   &AA<U]K97ET!    $9!4U1T"0   \'-E=%9A;\'5E\nM<R@H    4D4   !21@   %)\'    4D@   !220   %(J    4BL   !2+   \nM %(M    4BX   !2+P   %(P    4C,   !2-    %(U    4C8   !2-P  \nM %(X    4CD   !2.P   %(Z    4CP   !2/0   %(^    4C\\   !20   \nM %)!    4C$   !2,@   \'0(    =FES=6%L261T$P   &1I<W!L87EI;F=4\nM;U=I;F1O=W-2!@   %(\'    4E0   !T!@   &9I96QD<W0$    9G9A;%)8\nM    4EH   !T\'0   \'9I97=-86YI<$1I<W!L87E,:7-T5&AR97-H;VQD4EP \nM   H     "@     <RX    O;W!T+T%B87%U<R\\V+C$T+3$O4TU!+W-I=&4O\nM9W)A<&AI8W-#;VYF:6<N96YV=!0   !O;D-A94=R87!H:6-S4W1A<G1U< $ \nM  !S_@(    ## $, 0P!# $,$@8!!@$& 08!$@$& 08!# $, 0P!# $& 08!\nM!@$& 08!# $, 0P!# $, 0P!# $, 08$!@0, 0P!# (& P8#!@$& QP"$ $@\nM 08!#P(, @8!"0(, @P!!@$) 1 !!@$,! P"!@(0 @8!!@$) @P"!@() P8!\nM"0(, @8!!@(& A("$ (& 08"!@(5 A "%@,& 0D"!@(& P8#, $, 18!$@$#\nM 1<! P$* @P!#0$,!1(!#P$) @P!#04, 08") $) 0P!!@$, 0P!!@$# 0P!\nM&@$& 18! P$& 2(#$@$& 08""0(2 1("!@(/ 0\\$!@<& @\\!!@$) @\\!"0(/\nM 0D##P$)! \\!# (2 0D"$@$& 08$$@$)!0\\!!@(/ 0P!$ (/ 08!&P(/ @\\"\nM!@(, P8!%00& 0D"#P$/ @8!# $5 A4"#P$& 0P"#P,& 1(+# (& 0P"# (,\nM @P"# (, @8!!@$, @P"# $& 0D"# (& 0P"# (, 08!"0(, @8!!@0) @P"\nM!@$& PD"# 0& 0P"# (&!!("# (& 0D"# $2 0D"$ $/ 0P"# (0 @P"# (&\nM @P!$ (,! 8"$ $0 1 !$ $0 0D"$ () A ""0(0 08!"0(0 08!!@(, 0P!\nM# (0 @P&!@(0 1 !$ ,& A !"0(0 0D"$ $& 0D"$ () A !#P(0 @P!%@$,\nM A ""0(0 @8!!@$) A "!@(/ 08!!@(, 08%# $) @P#!@$& P8$"0(, P8!\nM"0(, 08!"0(0 P8!!@,, @P"$ $& 08!"0,, 0D## $, @P&!@H, @8!%0(,\nM 0P!# $, 0D## $2 08!"0(& @8!# ,0 0\\!# $2 0D!( 4- @P!# ,@ 10!\nM#P$& 0P"# (& 08!$@4, 1 "# $) P8!!@,0 1 !( $& 0\\#!@$& @P!"04,\nM 0D"# $& 08!!@$& 08!!@$& 08!!@$& 08!!@$& 08!!@$& 08!!@$& 08!\n(!@$& 08!!@$ \n \nend\n'),
    'outputKeywords':ON,
    'parameterized':OFF,
    'partsAndAssemblies':ON,
    'parval':OFF,
    'postOutput':OFF,
    'preDecomposition':ON,
    'restart':OFF,
    'restartEndStep':OFF,
    'restartIncrement':0,
    'restartStep':0,
    'restartWrite':OFF,
    'rezone':OFF,
    'runCalculator':OFF,
    'soils':OFF,
    'soliter':OFF,
    'solverTypes':['DIRECT'],
    'standard_parallel':ALL,
    'staticNonlinear':ON,
    'steadyStateTransport':OFF,
    'step':ON,
    'subGen':OFF,
    'subGenLibs':[],
    'subGenTypes':[],
    'submodel':OFF,
    'substrLibDefs':OFF,
    'substructure':OFF,
    'symmetricModelGeneration':OFF,
    'thermal':OFF,
    'tmpdir':'/tmp',
    'tracer':OFF,
    'visco':OFF,
}
analysis = StandardAnalysis(options)
status = analysis.run()
sys.exit(status)
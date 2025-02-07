-- Create the routing prefix table
--
CREATE TABLE SKYIT_IBS_ROUTING_PREFIX
(
  ROUTE_PREFIX varchar2(10) NOT NULL,
  ROUTE_TYPE varchar2(10) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- Create the product id table
--
CREATE TABLE SKYIT_IBS_PRODUCT
(
  EVENT_DIRECTION varchar2(1) NOT NULL,
  BNUM_PREFIX varchar2(10) NOT NULL,
  PRODUCT_ID varchar2(10) NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- Create the district table
--
CREATE TABLE SKYIT_IBS_DISTRICT
(
  DISTRICT varchar2(10) NOT NULL,
  DESCRIPTION varchar2(50)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- Create the olo table
--
CREATE TABLE SKYIT_IBS_OLO
(
  OLO varchar2(10) NOT NULL,
  SEND_ZDC varchar2(5) NOT NULL,
  OPID varchar2(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


-- INSERT INTO THE SKYIT_IBS_ROUTING_PREFIX TABLE
--
INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C97','NUE');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C99','GEO');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('00390180','OPE');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C82','OPE');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C50','NOM');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C59','NOM');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C80','OPE');

INSERT INTO SKYIT_IBS_ROUTING_PREFIX VALUES ('0039C60','PORT');


-- INSERT INTO THE SKYIT_IBS_PRODUCT TABLE
--
INSERT INTO SKYIT_IBS_PRODUCT VALUES ('O','800','FREE');

INSERT INTO SKYIT_IBS_PRODUCT VALUES ('O','803','FREE');

INSERT INTO SKYIT_IBS_PRODUCT VALUES ('O','204800','FREE');

INSERT INTO SKYIT_IBS_PRODUCT VALUES ('O','204803','FREE');

INSERT INTO SKYIT_IBS_PRODUCT VALUES ('O','C60','NPO');

INSERT INTO SKYIT_IBS_PRODUCT VALUES ('T','C60','NPO');

INSERT INTO SKYIT_IBS_PRODUCT VALUES ('I','C60','NPI');


-- INSERT INTO THE SKYIT_IBS_DISTRICT TABLE
--
INSERT INTO SKYIT_IBS_DISTRICT VALUES ('011','TORINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('015','BIELLA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0121','PINEROLO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0122','SUSA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0123','LANZO TORINESE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0124','RIVAROLO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0125','IVREA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0131','ALESSANDRIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0141','ASTI'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0142','CASALE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0143','NOVI LIGURE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0144','ACQUI TERME'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0161','VERCELLI'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0163','BORGOSESIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0165','AOSTA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0166','ST. VINCENT'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0171','CUNEO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0172','SAVIGLIANO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0173','ALBA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0174','MONDOVI'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0175','SALUZZO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0321','NOVARA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0322','ARONA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0323','BAVENO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0324','DOMODOSSOLA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('010','GENOVA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('019','SAVONA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0182','ALBENGA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0183','IMPERIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0184','SANREMO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0185','RAPALLO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0187','LA SPEZIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('02','MILANO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('039','MONZA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0331','BUSTO ARSIZIO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0332','VARESE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0362','SEREGNO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0371','LODI'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0377','CODOGNO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0381','VIGEVANO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0382','PAVIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0383','VOGHERA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0384','MORTARA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0385','STRADELLA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('031','COMO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('035','BERGAMO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0341','LECCO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0342','SONDRIO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0343','CHIAVENNA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0344','MENAGGIO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0345','S. PELLEGRINO TERME'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0346','CLUSONE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0363','TREVIGLIO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0364','BRENO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0373','CREMA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0374','SORESINA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('030','BRESCIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0365','SALO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0372','CREMONA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0375','CASALMAGGIORE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0376','MANTOVA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0386','OSTIGLIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0435','PIEVE DI CADORE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0436','CORTINA D AMPEZZO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0437','BELLUNO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0439','FELTRE'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0461','TRENTO'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0462','CAVALESE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0463','CLES');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0464','ROVERETO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0465','TIONE DI TRENTO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0471','BOLZANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0472','BRESSANONE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0473','MERANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0474','BRUNICO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('045','VERONA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('049','PADOVA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0424','BASSANO DEL GRAPPA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0425','ROVIGO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0426','ADRIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0429','ESTE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0442','LEGNAGO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0444','VICENZA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0445','SCHIO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('040','TRIESTE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('041','VENEZIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0421','S. DONA DI PIAVE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0422','TREVISO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0423','MONTEBELLUNA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0427','SPILIMBERGO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0428','TARVISIO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0431','CERVIGNANO DEL FRIULI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0432','UDINE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0433','TOLMEZZO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0434','PORDENONE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0438','CONEGLIANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0481','GORIZIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('051','BOLOGNA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('059','MODENA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0521','PARMA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0522','REGGIO NELL EMILIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0523','PIACENZA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0524','FIDENZA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0525','FORNOVO DI TARO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0532','FERRARA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0533','COMACCHIO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0534','PORRETTA TERME');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0535','MIRANDOLA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0536','SASSUOLO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0542','IMOLA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('071','ANCONA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0541','RIMINI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0543','FORLI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0544','RAVENNA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0545','LUGO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0546','FAENZA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0547','CESENA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0549','S.MARINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0721','PESARO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0722','URBINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0731','JESI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0732','FABRIANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0733','MACERATA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0737','CAMERINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('050','PISA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('055','FIRENZE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0564','GROSSETO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0565','PIOMBINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0566','FOLLONICA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0571','EMPOLI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0572','MONTECATINI TERME');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0573','PISTOIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0574','PRATO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0575','AREZZO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0577','SIENA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0578','CHIANCIANO TERME');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0583','LUCCA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0584','VIAREGGIO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0585','MASSA CARRARA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0586','LIVORNO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0587','PONTEDERA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0588','VOLTERRA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('070','CAGLIARI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('075','PERUGIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('079','SASSARI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0734','FERMO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0735','S. BENEDETTO DEL TRONTO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0736','ASCOLI PICENO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0742','FOLIGNO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0743','SPOLETO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0744','TERNI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0781','IGLESIAS');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0782','LANUSEI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0783','ORISTANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0784','NUORO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0785','MACOMER');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0789','OLBIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('06','ROMA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0746','RIETI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0761','VITERBO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0763','ORVIETO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0765','POGGIO MIRTETO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0766','CIVITAVECCHIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0771','FORMIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0773','LATINA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0774','TIVOLI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0775','FROSINONE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0776','CASSINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('081','NAPOLI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('089','SALERNO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0823','CASERTA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0824','BENEVENTO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0825','AVELLINO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0827','S. ANGELO DEI LOMBARDI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0828','BATTIPAGLIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0835','MATERA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0971','POTENZA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0972','MELFI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0973','LAGONEGRO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0974','VALLO DELLA LUCANIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0975','SALA CONSILINA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0976','MURO LUCANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('080','BARI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('099','TARANTO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0831','BRINDISI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0832','LECCE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0833','GALLIPOLI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0836','MAGLIE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0881','FOGGIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0882','S. SEVERO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0883','ANDRIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0884','MANFREDONIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0885','CERIGNOLA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('085','PESCARA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0861','TERAMO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0862','L AQUILA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0863','AVEZZANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0864','SULMONA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0865','ISERNIA'); 

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0871','CHIETI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0872','LANCIANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0873','VASTO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0874','CAMPOBASSO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0875','TERMOLI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0961','CATANZARO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0962','CROTONE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0963','VIBO VALENTIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0964','LOCRI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0965','REGGIO DI CALABRIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0966','PALMI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0967','SOVERATO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0968','LAMEZIA TERME');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0981','CASTROVILLARI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0982','PAOLA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0983','ROSSANO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0984','COSENZA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0985','SCALEA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('090','MESSINA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('091','PALERMO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('095','CATANIA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0921','CEFALU');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0922','AGRIGENTO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0923','TRAPANI');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0924','ALCAMO');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0925','SCIACCA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0931','SIRACUSA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0932','RAGUSA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0933','CALTAGIRONE');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0934','CALTANISETTA');

INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0935','ENNA');
 
INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0941','PATTI');
 
INSERT INTO SKYIT_IBS_DISTRICT VALUES ('0942','TAORMINA');


-- INSERT INTO THE SKYIT_IBS_OLO TABLE
--
INSERT INTO SKYIT_IBS_OLO VALUES ('TIM','N','204');

INSERT INTO SKYIT_IBS_OLO VALUES ('SKY','N','');
CREATE TABLE MSRN_RANGES 
( 
  RANGE_START VARCHAR2(20) NOT NULL,
  RANGE_END VARCHAR2(20) NOT NULL,
  TADIG VARCHAR2(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802010000', '447802099999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802050000', '447802059999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802100000', '447802109999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802110000', '447802119999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802120000', '447802129999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802130000', '447802139999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802140000', '447802149999', 'GBRCN');

INSERT INTO MSRN_RANGES (RANGE_START, RANGE_END, TADIG) 
VALUES ('447802150000', '447802159999', 'GBRCN');

-- Add three new columns to the CDR_INPUT_OMP table
--
alter table cdr_input_omp
  add (FACILITIES varchar2(60),
       CREDIT_DEBIT_IND char(1),
       CSS_RETRIEVAL_NUMBER varchar2(15));

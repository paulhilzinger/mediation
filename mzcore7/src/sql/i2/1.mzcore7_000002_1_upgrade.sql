-- Changes required for MZ 7.2 SP2 upgrade
--
CREATE INDEX default_dupbatch_txn_idx ON DEFAULT_DUPBATCH(TXN);
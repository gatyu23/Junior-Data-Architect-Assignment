DROP SCHEMA IF EXISTS dwh;
CREATE SCHEMA IF NOT EXISTS dwh;                                              

DROP TABLE IF EXISTS dwh.vehicle;
  CREATE TABLE IF NOT EXISTS dwh.vehicle (                                      
      _id INTEGER PRIMARY KEY,
      mispar_rechev INTEGER UNIQUE NOT NULL, 
      shnat_yitzur INTEGER ,
      kvutzat_zihum INTEGER CHECK (kvutzat_zihum IS NULL OR kvutzat_zihum >= 0),
      tozeret_nm VARCHAR(50),
      tokef_dt DATE ,
      moed_aliya_lakvish DATE,
      sug_delek_nm VARCHAR(50),
      load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
  );
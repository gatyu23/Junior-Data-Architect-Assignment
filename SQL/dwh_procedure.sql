CREATE OR REPLACE FUNCTION load_dwh_vehicle()
  RETURNS INTEGER AS $$
  DECLARE
      rows_inserted INTEGER;
  BEGIN
      INSERT INTO dwh.vehicle (
          _id,
          mispar_rechev,
          shnat_yitzur,
          kvutzat_zihum,
          tozeret_nm,
          tokef_dt,
          moed_aliya_lakvish,
          sug_delek_nm,
          load_ts
      )
      SELECT
          -- _id: Convert to INTEGER
          CASE
              WHEN _id IS NULL OR TRIM(_id) IN ('', 'null', 'NULL', 'None') THEN NULL
              WHEN TRIM(_id) ~ '^[0-9]+$' THEN TRIM(_id)::INTEGER
              ELSE NULL
          END AS _id,

          -- mispar_rechev: Convert to INTEGER
          CASE
              WHEN mispar_rechev IS NULL OR TRIM(mispar_rechev) IN ('', 'null', 'NULL', 'None') THEN NULL
              WHEN TRIM(mispar_rechev) ~ '^[0-9]+$' THEN TRIM(mispar_rechev)::INTEGER
              ELSE NULL
          END AS mispar_rechev,

          -- shnat_yitzur: Validate range 1900-2026
          CASE
              WHEN shnat_yitzur IS NULL OR TRIM(shnat_yitzur) IN ('', 'null', 'NULL', 'None') THEN NULL
              WHEN TRIM(shnat_yitzur) ~ '^[0-9]+$' THEN
                  CASE
                      WHEN TRIM(shnat_yitzur)::INTEGER BETWEEN 1900 AND 2026 THEN TRIM(shnat_yitzur)::INTEGER
                      ELSE NULL
                  END
              ELSE NULL
          END AS shnat_yitzur,

          -- kvutzat_zihum: Convert to INTEGER
          CASE
              WHEN kvutzat_zihum IS NULL OR TRIM(kvutzat_zihum) IN ('', 'null', 'NULL', 'None') THEN NULL
              WHEN TRIM(kvutzat_zihum) ~ '^[0-9]+(\.[0-9]+)?$' THEN TRIM(kvutzat_zihum)::NUMERIC::INTEGER
              ELSE NULL
              END AS kvutzat_zihum,

          -- tozeret_nm: Standardize manufacturer names (Hebrew to English Standard)
          CASE
              WHEN tozeret_nm IS NULL OR TRIM(tozeret_nm) IN ('', 'null', 'NULL', 'None') THEN NULL
              -- Japanese
              WHEN TRIM(tozeret_nm) LIKE 'טויוטה%' THEN 'TOYOTA'
              WHEN TRIM(tozeret_nm) LIKE 'הונדה%' THEN 'HONDA'
              WHEN TRIM(tozeret_nm) LIKE 'מזדה%' THEN 'MAZDA'
              WHEN TRIM(tozeret_nm) LIKE 'מיצובישי%' THEN 'MITSUBISHI'
              WHEN TRIM(tozeret_nm) LIKE 'ניסאן%' THEN 'NISSAN'
              WHEN TRIM(tozeret_nm) LIKE 'סובארו%' THEN 'SUBARU'
              WHEN TRIM(tozeret_nm) LIKE 'סוזוקי%' OR TRIM(tozeret_nm) LIKE 'מרוטי%' THEN 'SUZUKI'
              WHEN TRIM(tozeret_nm) LIKE 'לקסוס%' THEN 'LEXUS'
              WHEN TRIM(tozeret_nm) LIKE 'איסוזו%' THEN 'ISUZU'
              WHEN TRIM(tozeret_nm) LIKE 'דייהטסו%' THEN 'DAIHATSU'
              -- Korean
              WHEN TRIM(tozeret_nm) LIKE 'יונדאי%' THEN 'HYUNDAI'
              WHEN TRIM(tozeret_nm) LIKE 'קיה%' THEN 'KIA'
              WHEN TRIM(tozeret_nm) LIKE 'סאנגיונג%' OR TRIM(tozeret_nm) LIKE 'קיי גי מוביליט%' THEN 'SSANGYONG'
              WHEN TRIM(tozeret_nm) LIKE 'דייהו%' THEN 'DAEWOO'
              -- German
              WHEN TRIM(tozeret_nm) LIKE 'ב מ וו%' THEN 'BMW'
              WHEN TRIM(tozeret_nm) LIKE 'מרצדס%' THEN 'MERCEDES-BENZ'
              WHEN TRIM(tozeret_nm) LIKE 'פולקסווגן%' THEN 'VOLKSWAGEN'
              WHEN TRIM(tozeret_nm) LIKE 'אאודי%' OR TRIM(tozeret_nm) LIKE 'אודי%' THEN 'AUDI'
              WHEN TRIM(tozeret_nm) LIKE 'פורשה%' THEN 'PORSCHE'
              WHEN TRIM(tozeret_nm) LIKE 'אופל%' THEN 'OPEL'
              WHEN TRIM(tozeret_nm) LIKE 'סמארט%' OR TRIM(tozeret_nm) LIKE 'אמ.סי.סי%' THEN 'SMART'
              WHEN TRIM(tozeret_nm) LIKE 'דימלרקריזלר%' THEN 'DAIMLERCHRYSLER'
              -- French/European
              WHEN TRIM(tozeret_nm) LIKE 'פיג''ו%' THEN 'PEUGEOT'
              WHEN TRIM(tozeret_nm) LIKE 'רנו%' THEN 'RENAULT'
              WHEN TRIM(tozeret_nm) LIKE 'סיטרואן%' THEN 'CITROEN'
              WHEN TRIM(tozeret_nm) LIKE 'דאציה%' THEN 'DACIA'
              WHEN TRIM(tozeret_nm) LIKE 'סיאט%' THEN 'SEAT'
              WHEN TRIM(tozeret_nm) LIKE 'סקודה%' THEN 'SKODA'
              -- Italian
              WHEN TRIM(tozeret_nm) LIKE 'פיאט%' THEN 'FIAT'
              WHEN TRIM(tozeret_nm) LIKE 'אלפא רומיאו%' THEN 'ALFA ROMEO'
              WHEN TRIM(tozeret_nm) LIKE 'מזארטי%' THEN 'MASERATI'
              WHEN TRIM(tozeret_nm) LIKE 'לנצ%' THEN 'LANCIA'
              WHEN TRIM(tozeret_nm) LIKE 'פרארי%' THEN 'FERRARI'
              -- American
              WHEN TRIM(tozeret_nm) LIKE 'פורד%' THEN 'FORD'
              WHEN TRIM(tozeret_nm) LIKE 'שברולט%' THEN 'CHEVROLET'
              WHEN TRIM(tozeret_nm) LIKE 'ג''יפ%' THEN 'JEEP'
              WHEN TRIM(tozeret_nm) LIKE 'טסלה%' THEN 'TESLA'
              WHEN TRIM(tozeret_nm) LIKE 'קאדילאק%' THEN 'CADILLAC'
              WHEN TRIM(tozeret_nm) LIKE 'קרייזלר%' THEN 'CHRYSLER'
              WHEN TRIM(tozeret_nm) LIKE 'ביואיק%' THEN 'BUICK'
              WHEN TRIM(tozeret_nm) LIKE 'ג''י.אמ.סי%' THEN 'GMC'
              WHEN TRIM(tozeret_nm) LIKE 'האמר%' THEN 'HUMMER'
              -- British / Swedish
              WHEN TRIM(tozeret_nm) LIKE 'וולבו%' THEN 'VOLVO'
              WHEN TRIM(tozeret_nm) LIKE 'לנדרובר%' THEN 'LAND ROVER'
              WHEN TRIM(tozeret_nm) LIKE 'יגואר%' THEN 'JAGUAR'
              WHEN TRIM(tozeret_nm) LIKE 'מ.ג%' THEN 'MG'
              WHEN TRIM(tozeret_nm) LIKE 'רובר%' THEN 'ROVER'
              WHEN TRIM(tozeret_nm) LIKE 'סאאב%' THEN 'SAAB'
              WHEN TRIM(tozeret_nm) LIKE 'בנטלי%' THEN 'BENTLEY'
              WHEN TRIM(tozeret_nm) LIKE 'אסטון מרטין%' THEN 'ASTON MARTIN'
              WHEN TRIM(tozeret_nm) LIKE 'לוטוס%' THEN 'LOTUS'
              -- Chinese (Corrected Names)
              WHEN TRIM(tozeret_nm) LIKE 'גילי%' THEN 'GEELY'
              WHEN TRIM(tozeret_nm) LIKE 'בי ווי די%' THEN 'BYD'
              WHEN TRIM(tozeret_nm) LIKE 'צ''רי%' THEN 'CHERY'
              WHEN TRIM(tozeret_nm) LIKE 'אורה%' THEN 'ORA'
              WHEN TRIM(tozeret_nm) LIKE 'ניאו%' THEN 'NIO'
              WHEN TRIM(tozeret_nm) LIKE 'זיקר%' THEN 'ZEEKR'
              WHEN TRIM(tozeret_nm) LIKE 'ג''אקו%' THEN 'JAECOO'
              WHEN TRIM(tozeret_nm) LIKE 'ג''אק%' THEN 'JAC'
              WHEN TRIM(tozeret_nm) LIKE 'מקסוס%' THEN 'MAXUS'
              WHEN TRIM(tozeret_nm) LIKE 'סרס%' THEN 'SERES'
              WHEN TRIM(tozeret_nm) LIKE 'סקיוול%' THEN 'SKYWELL'
              WHEN TRIM(tozeret_nm) LIKE 'איווייס%' THEN 'AIWAYS'
              WHEN TRIM(tozeret_nm) LIKE 'אומודה%' THEN 'OMODA'
              WHEN TRIM(tozeret_nm) LIKE 'ליפמוטור%' THEN 'LEAPMOTOR'
              WHEN TRIM(tozeret_nm) LIKE 'לינק אנד קו%' THEN 'LYNK & CO'
              WHEN TRIM(tozeret_nm) LIKE 'דיפאל%' THEN 'DEEPAL'
              WHEN TRIM(tozeret_nm) LIKE 'וואי%' THEN 'WEY'
              WHEN TRIM(tozeret_nm) LIKE 'וויה%' THEN 'VOYAH'
              WHEN TRIM(tozeret_nm) LIKE 'פורתינג%' THEN 'FORTHING'
              WHEN TRIM(tozeret_nm) LIKE 'גי.אי.סי%' OR TRIM(tozeret_nm) LIKE 'גיי.איי.סי%' OR TRIM(tozeret_nm) LIKE 'איון%' THEN 'GAC'
              WHEN TRIM(tozeret_nm) LIKE 'אף אי דאבל יו%' THEN 'FAW'
              -- Fallback
              ELSE UPPER(TRIM(tozeret_nm))
          END AS tozeret_nm,

          -- tokef_dt: Validate date format and range
          CASE
              WHEN tokef_dt IS NULL OR TRIM(tokef_dt) IN ('', 'null', 'NULL', 'None') THEN NULL
              WHEN TRIM(tokef_dt) ~ '^\d{4}-\d{2}-\d{2}$' THEN
                  CASE
                      WHEN TRIM(tokef_dt)::DATE BETWEEN '1900-01-01' AND '2030-12-31' THEN TRIM(tokef_dt)::DATE
                      ELSE NULL
                  END
              ELSE NULL
          END AS tokef_dt,

          -- moed_aliya_lakvish: Handle YYYY-M or YYYY-MM format
          CASE
              WHEN moed_aliya_lakvish IS NULL OR TRIM(moed_aliya_lakvish) IN ('', 'null', 'NULL', 'None') THEN NULL
              WHEN TRIM(moed_aliya_lakvish) ~ '^\d{4}-\d{1,2}$' THEN
                  CASE
                      WHEN (TRIM(moed_aliya_lakvish) || '-01')::DATE BETWEEN '1900-01-01' AND CURRENT_DATE
                      THEN (TRIM(moed_aliya_lakvish) || '-01')::DATE
                      ELSE NULL
                  END
              ELSE NULL
          END AS moed_aliya_lakvish,

          -- sug_delek_nm: Trim and handle NULLs
          CASE
              WHEN sug_delek_nm IS NULL OR TRIM(sug_delek_nm) IN ('', 'null', 'NULL', 'None') THEN NULL
              ELSE TRIM(sug_delek_nm)
          END AS sug_delek_nm,

          -- load_ts: Current timestamp
          CURRENT_TIMESTAMP AS load_ts

      FROM mrr_fct.vehicle
      WHERE _id IS NOT NULL AND TRIM(_id) ~ '^[0-9]+$';
      
      GET DIAGNOSTICS rows_inserted = ROW_COUNT;
      RETURN rows_inserted;
  END;
  $$ LANGUAGE plpgsql;

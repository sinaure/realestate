CREATE TABLE mutations_stats_by_year AS (SELECT 
m1.libtypbien as libtypbien,
m1.l_codinsee[1] as insee_cod,
sum(m1.valeurfonc) as sum_val_fonc,
count(m1.idmutation) as total,
c1.nom as nom,
sum(m1.sterr) as sum_sterr,
sum(m1.sbati) as sum_sbati,
ST_X(ST_Transform(ST_Centroid(c1.geom), 2154)) as longitude , ST_Y(ST_Transform(ST_Centroid(c1.geom), 2154)) as latitude,
make_date(anneemut, moismut, 01) as date_mut,
m1.anneemut as anneemut
FROM   dvf.mutation m1 LEFT JOIN public."communes-20210101" c1 ON m1.l_codinsee[1] = c1.insee 
WHERE coddep = '06' or coddep='83'
GROUP BY anneemut, date_mut, insee_cod, libtypbien, nom, c1.geom
ORDER BY anneemut DESC, date_mut DESC, sum_val_fonc DESC, total DESC, insee_cod);

ALTER TABLE mutations_stats_by_year ADD PRIMARY KEY (date_mut, libtypbien, insee_cod);
CREATE TABLE mutations_stats (LIKE mutations_stats_by_year INCLUDING DEFAULTS INCLUDING CONSTRAINTS EXCLUDING INDEXES);
SELECT * FROM create_hypertable('mutations_stats', 'date_mut');
INSERT INTO mutations_stats SELECT * FROM mutations_stats_by_year;

CREATE TABLE mutations_stats_summary_yearly
AS
SELECT nom,
       libtypbien,
       time_bucket(INTERVAL '365 days', date_mut) AS bucket,
       SUM(sum_val_fonc) as sum_val_fonc,
       SUM(total) as total,
       SUM(sum_sterr) as sum_sterr,
       SUM(sum_sbati) as sum_sbati
FROM mutations_stats
GROUP BY nom,libtypbien, bucket ORDER BY bucket DESC, nom ASC, libtypbien DESC;

CREATE TABLE mutations_trend AS (SELECT bucket, nom, libtypbien,sum_val_fonc, total, sum_sterr, sum_sbati,
       sum_val_fonc-lag(sum_val_fonc) over (partition by nom,libtypbien order by bucket)  as increase_val,
	   total-lag(total) over (partition by nom,libtypbien order by bucket)  as increase_tx
from mutations_stats_summary_yearly GROUP BY bucket, nom,libtypbien, sum_val_fonc, total, sum_sterr, sum_sbati ORDER BY bucket DESC,nom ASC, increase_val ASC, increase_tx ASC);

CREATE TABLE mutations_trend_villa AS (SELECT anneemut, nom, insee_cod, sum_val_fonc, total, sum_sterr, sum_sbati, longitude, latitude,
       sum_val_fonc-lag(sum_val_fonc) over (partition by nom order by anneemut)  as increase_val,
	   total-lag(total) over (partition by nom order by anneemut)  as increase_tx
from mutations_stats where libtypbien='UNE MAISON' GROUP BY anneemut, nom, insee_cod, sum_val_fonc, total, sum_sterr, sum_sbati, longitude, latitude ORDER BY anneemut DESC,increase_val ASC, increase_tx ASC);

CREATE TABLE mutations_trend_land AS (SELECT anneemut, nom, insee_cod, sum_val_fonc, total, sum_sterr, sum_sbati, longitude, latitude,
       sum_val_fonc-lag(sum_val_fonc) over (partition by nom order by anneemut)  as increase_val,
	   total-lag(total) over (partition by nom order by anneemut)  as increase_tx
from mutations_stats where libtypbien like '%TERRAIN%' GROUP BY anneemut, nom, insee_cod, sum_val_fonc, total, sum_sterr, sum_sbati, longitude, latitude ORDER BY anneemut DESC,increase_val ASC, increase_tx ASC);

CREATE TABLE mutations_trend_apt AS (SELECT anneemut, nom, insee_cod, sum_val_fonc, total, sum_sterr, sum_sbati, longitude, latitude,
       sum_val_fonc-lag(sum_val_fonc) over (partition by nom order by anneemut)  as increase_val,
	   total-lag(total) over (partition by nom order by anneemut)  as increase_tx
from mutations_stats where libtypbien='UN APPARTEMENT' GROUP BY anneemut, nom, insee_cod, sum_val_fonc, total, sum_sterr, sum_sbati, longitude, latitude ORDER BY anneemut DESC,increase_val ASC, increase_tx ASC);


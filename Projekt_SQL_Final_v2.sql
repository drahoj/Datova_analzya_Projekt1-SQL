-- Vytvoreni klonu tabulky countries - z duvodu, aby se sjednotily nazvy a bylo mozne delat joiny
CREATE TABLE countries_2 AS
	SELECT
		*
	FROM countries;

	
-- UPDATE tabulky countries_2 (uprava nazvu hlavniho mesta vuci tabulce weather)
UPDATE countries_2 SET capital_city = 'Prague' WHERE capital_city = 'Praha';
UPDATE countries_2 SET capital_city = 'Brussels' WHERE capital_city = 'Bruxelles [Brussel]';
UPDATE countries_2 SET capital_city = 'Helsinki' WHERE capital_city = 'Helsinki [Helsingfors]';
UPDATE countries_2 SET capital_city = 'Kiev' WHERE capital_city = 'Kyiv';
UPDATE countries_2 SET capital_city = 'Lisbon' WHERE capital_city = 'Lisboa';
UPDATE countries_2 SET capital_city = 'Luxembourg' WHERE capital_city = 'Luxembourg [Luxemburg/L';
UPDATE countries_2 SET capital_city = 'Rome' WHERE capital_city = 'Roma';
UPDATE countries_2 SET capital_city = 'Vienna' WHERE capital_city = 'Wien';
UPDATE countries_2 SET capital_city = 'Bucharest' WHERE capital_city = 'Bucuresti';
UPDATE countries_2 SET capital_city = 'Warsaw' WHERE capital_city = 'Warszawa';
UPDATE countries_2 SET capital_city = 'Athens' WHERE capital_city = 'Athenai';

-- UPDATE tabulky countries_2 (uprava nazvu country vuci tabulce covid19_basic_differences)
UPDATE countries_2 SET country = 'Burma' WHERE country = 'Myanmar';
UPDATE countries_2 SET country = 'Cabo Verde' WHERE country = 'Cape Verde';
UPDATE countries_2 SET country = 'Congo (Brazzaville)' WHERE country = 'Congo';
UPDATE countries_2 SET country = 'Congo (Kinshasa)' WHERE country = 'The Democratic Republic of Congo';
UPDATE countries_2 SET country = "Cote d'Ivoire" WHERE country = 'Ivory Coast';
UPDATE countries_2 SET country = 'Czechia' WHERE country = 'Czech Republic';
UPDATE countries_2 SET country = 'Eswatini' WHERE country = 'Swaziland';
UPDATE countries_2 SET country = 'Fiji' WHERE country = 'Fiji Islands';
UPDATE countries_2 SET country = 'Holy See' WHERE country = 'Holy See (Vatican City State)';
UPDATE countries_2 SET country = 'Korea, South' WHERE country = 'South Korea';
UPDATE countries_2 SET country = 'Libya' WHERE country = 'Libyan Arab Jamahiriya';
UPDATE countries_2 SET country = 'Micronesia' WHERE country = 'Micronesia, Federated States of';
UPDATE countries_2 SET country = 'Russia' WHERE country = 'Russian Federation';
UPDATE countries_2 SET country = 'US' WHERE country = 'United States';

-- Vytvoreni klonu tabulky covid19_tests - z duvodu, aby se sjednotily nazvy a bylo mozne delat joiny
CREATE TABLE covid_test
	SELECT
		* 
	FROM covid19_tests;

-- UPDATE tabulky covid_test (uprava nazvu country vuci tabulce covid19_basic_differences)
UPDATE covid_test SET country = 'Burma' WHERE country = 'Myanmar';
UPDATE covid_test SET country = 'Congo (Kinshasa)' WHERE country = 'Democratic Republic of Congo';
UPDATE covid_test SET country = 'Czechia' WHERE country = 'Czech Republic';
UPDATE covid_test SET country = 'Korea, South' WHERE country = 'South Korea';
UPDATE covid_test SET country = 'Taiwan*' WHERE country = 'Taiwan';
UPDATE covid_test SET country = 'US' WHERE country = 'United States';


-- Pomocna tabulka, ktera slouzi k vypoctu podilu jednotlivych nabozenstvi
CREATE TABLE religions_2 AS
WITH relig AS ( #docasna tabulka, ze sloupce religion veme promenne pro jednotlive nabozenstvi a da je do samostatneho sloupce
	SELECT
		*,
		MAX(CASE WHEN religion = 'Christianity' THEN population END) AS religion_Christianity_1,
		MAX(CASE WHEN religion = 'Islam' THEN population END) AS religion_Islam_1,
		MAX(CASE WHEN religion = 'Unaffiliated religions' THEN population END) AS Unaffiliated_religions_1,
		MAX(CASE WHEN religion = 'Hinduism' THEN population END) AS religion_Hinduism_1,
		MAX(CASE WHEN religion = 'Buddhism' THEN population END) AS religion_Buddhism_1,
		MAX(CASE WHEN religion = 'Folk religions' THEN population END) AS religion_Folk_religions_1,
		MAX(CASE WHEN religion = 'Other religions' THEN population END) AS religion_Other_religions_1,
		SUM(population) as pop
	FROM religions
	WHERE year = 2020 #data se berou za rok 2020, je to nejblize k roku v COVID tabulce
	GROUP BY country
)
	SELECT
		*,
		CASE WHEN religion_Christianity_1 != 0 THEN ROUND(religion_Christianity_1/SUM(pop)*100,1) #pokud hodnota v danem sloupci neni nula, pak spocitej procentualni velikost daneho nabozenstvi
			ELSE 0 END AS religion_Christianity,
		CASE WHEN religion_Islam_1 != 0 THEN ROUND(religion_Islam_1/SUM(pop)*100,1) 
			ELSE 0 END AS religion_Islam,
		CASE WHEN Unaffiliated_religions_1 != 0 THEN ROUND(Unaffiliated_religions_1/SUM(pop)*100,1) 
			ELSE 0 END AS Unaffiliated_religions,
		CASE WHEN religion_Hinduism_1 != 0 THEN ROUND(religion_Hinduism_1/SUM(pop)*100,1) 
			ELSE 0 END AS religion_Hinduism,
		CASE WHEN religion_Buddhism_1 != 0 THEN ROUND(religion_Buddhism_1/SUM(pop)*100,1) 
			ELSE 0 END AS religion_Buddhism,
		CASE WHEN religion_Folk_religions_1 != 0 THEN ROUND(religion_Folk_religions_1/SUM(pop)*100,1) 
			ELSE 0 END AS religion_Folk_religions,
		CASE WHEN religion_Other_religions_1 != 0 THEN ROUND(religion_Other_religions_1/SUM(pop)*100,1) 
			ELSE 0 END AS religion_Other_religions
	FROM relig
	GROUP BY country;

	
CREATE TABLE life_exp_proj AS #pomocna tabulka pro vypocet hodnoty - rozdil mezi ocekavanou dobou doziti v roce 1965 a v roce 2015 - staty, ve kterych probehl rychly rozvoj mohou reagovat jinak nez zeme, ktere jsou vyspele uz delsi dobu
WITH jedna_1965 AS ( #pomocne tabulky pro hodnoty life_expectancy v roce 1965 a 2015
	SELECT
		*
	FROM life_expectancy
	WHERE year = '1965'
),
druha_2015 AS (
	SELECT
		*
	FROM life_expectancy
	WHERE year = '2015'
)
SELECT #odectou se hodnoty ve dvou sloupcich a ulozi se do noveho sloupce
	j.country,
	j.life_expectancy AS life_expectancy_1965,
	d.life_expectancy AS life_expectancy_2015,
	d.life_expectancy - j.life_expectancy AS rozdil
	FROM jedna_1965 j
	LEFT JOIN druha_2015 d
		ON j.country = d.country;


		
	
CREATE TABLE zakladni_2		#pomocna tabulka, vznikne spojenim tabulek covid19_basic_differences a covid_test
	SELECT					#doplni tabulku covid19_basic_differences o informace o poctu provedenych testu
	 	dif.date AS dif_date,
	 	test.date AS test_date,
 		dif.country AS country_dif,
 		test.country AS country_test,
 		dif.confirmed,
 		test.tests_performed
	FROM covid19_basic_differences dif
	LEFT JOIN covid_test test
		ON dif.country = test.country
		AND dif.date = test.date
	UNION
	SELECT
	 	dif.date AS dif_date,
	 	test.date AS test_date,
 		dif.country AS country_dif,
 		test.country AS country_test,
 		dif.confirmed,
 		test.tests_performed
	FROM covid19_basic_differences dif
	RIGHT JOIN covid_test test
		ON dif.country = test.country
		AND dif.date = test.date

UPDATE zakladni_2 SET country_dif = 'Australia' WHERE country_test = 'Australia';
UPDATE zakladni_2 SET country_dif = 'Canada' WHERE country_test = 'Canada';
UPDATE zakladni_2 SET country_dif = 'China' WHERE country_test = 'China';
UPDATE zakladni_2 SET country_dif = 'Hong Kong' WHERE country_test = 'Hong Kong';
UPDATE zakladni_2 SET country_dif = 'Macedonia' WHERE country_test = 'Macedonia';
UPDATE zakladni_2 SET country_dif = 'Palestine' WHERE country_test = 'Palestine';		


CREATE TABLE zakladni #vznikne upravnenim predesle tabulky a bude obsahovat o informace o poctu provedenych testu a take poctu nakazenych osob
SELECT
	CASE WHEN dif_date IS NOT NULL THEN dif_date #sjednoceni data, aby bylo u vsech radku
			ELSE test_date END AS date,
	CASE WHEN country_dif IS NULL THEN country_test #odstraneni anomalie spojenim tabulek, kde chybely infroamce ve sloupci country_dif (jednalo se o nekolik radku pro country Mexico, Korea, Taiwain a Thailand)
			ELSE country_dif END AS country,		
	confirmed,
	tests_performed
	FROM zakladni_2;
	
DROP TABLE zakladni_2 #smazani pomocne tabulky, ketra jiz nebude potreba


CREATE TABLE staty AS # tabulka pro vypocet casovych promennych a promennych specifickych pro dany stat
WITH GDP_5 AS ( #pomocna tabulka na vypocet HDP (GDP) a detskou umrtnost
	SELECT
		country,
		GDP,
		ROUND(GDP/population,2) AS GDP_na_osobu, #vypocet HDP na obyvatele - HDP/poctem obyvatel zaukroulene na 2 desetinna mista
		mortaliy_under5 #-- Detska umrtnost
	FROM ecONomies e
	WHERE year = '2019' #data brana z roku 2019, ve 2020 nebyla data dostupna
),
GINI_k AS ( #pomocna tabulka na vypocet GINI koeficientu
	SELECT DISTINCT
		country,
		gini,
		year
	FROM economies
	WHERE gini IS NOT NULL #pro danou zemi se bere hodnota, ktera je nenulova (kazda zeme muze mit hodnotu z jineho roku)
	GROUP BY country
)
SELECT
	zak.*,
	c.population AS Pocet_obyvatel,
	CASE	
		WHEN WEEKDAY(zak.date) <= 4 THEN "pracovni den" #urceni, zda dany den je pracovni nebo vikend
		ELSE "vikend" END AS pracovni_den_vikend, #funkce weekday vrati hodnotu dne v tydnu (0-4 pracovni dny, 5 a 6 vikend)
	CASE WHEN month(zak.date) IN (12, 1, 2) THEN '0' #ZIMA (prosinec, leden, unor) #urceni rocniho odbodbi, fce month vrati hodnotu mesice v roce (1 az 12)
      	WHEN month(zak.date) IN (3, 4, 5) THEN '1' #jaro (brezen, duben, kveten)
      	WHEN month(zak.date) IN (6, 7, 8) THEN '2' #leto (cerven, cervenec, srpen)
      	WHEN month(zak.date) IN (9, 10, 11) THEN '3' #podzim (zari, rijen, listopad)
 	  	END AS rocni_odbobi,
 	c.population_density, #hustota zalidneni
 	g.GDP_na_osobu, #HDP na obyvatele
  	gi.gini, #GINI koeficient 
  	g.mortaliy_under5, # Detska umrtnost
  	c.median_age_2018, #median veku obyvatel v roce 2018
  	rel.religion_Christianity, #podily jednotlivych nabozenstvi
  	rel.religion_Islam,
  	rel.Unaffiliated_religions,
  	rel.religion_Hinduism,
  	rel.religion_Buddhism,
  	rel.religion_Folk_religions AS Folk_religions,
  	rel.religion_Other_religions AS Other_religions,
  	lif.rozdil as Rozdil_Life_expect #rozdil mezi ocekavanou dobou doziti v roce 1965 a v roce 2015
FROM zakladni zak
LEFT JOIN countries_2 c
	ON zak.country = c.country
LEFT JOIN GDP_5 g
	ON zak.country = g.country
LEFT JOIN GINI_K gi
	ON zak.country = gi.country
LEFT JOIN religions_2 rel
	ON zak.country = rel.country
LEFT JOIN life_exp_proj lif
	ON zak.country = lif.country;



-- Pocasi (ovlivnuje chovani lidi a take schopnost sireni viru) 
CREATE TABLE pocasi AS #pomocna tabulka pro vypocet a vytvoreni view pro vsechny promenne v ramci pocasi
 	SELECT
		w.*,
		c.country,
		CAST (TRIM (TRAILING 'km/h' FROM w.gust) AS integer) AS gust_2, #odtraneni km/h z hodnoty sloupce gust, prevod na integer a zapis do noveho sloupce gust_2
		CAST (TRIM (TRAILING ' °c' FROM temp) AS integer) AS temp_2
		FROM weather w 
	LEFT JOIN  countries_2 c
		ON w.city = c.capital_city
 	WHERE date >= '2020-01-22' AND city IS NOT NULL;
 

 	
CREATE TABLE weather_2 AS # vytvoreni tabulky, ktere bude obsahovat vsechny pozadovane promenne z oblasti pocasi
   WITH prum_den_teplota AS (
  	SELECT					
 		date,					
 		city,
 		country,
 		AVG(temp_2) AS Prum_den_tep #prumerna denni teplota
 	FROM pocasi
 	WHERE time IN ('06:00','09:00','12:00','15:00','18:00') #teplota se vypocita jen z dennich hodnot, tj od 6 do 18h 
   	GROUP BY city,date
   ),
prsi AS (  #zjisteni, kolik hodin za den prselo
	SELECT
		date,
		city,
		country,
		COUNT(time)*3 AS kolik_hodin_prselo #zjisti se, v kolika dennich blocich prselo a vynasobi se 3, aby se to prevedlo na hodiny (jeden blok=3 hodiny)
	FROM pocasi
	WHERE rain > '0.0 mm' #jen kdyz prsi
	GROUP BY city,date
),
vitr AS (
	SELECT
		date,
		city,
		country,
 		MAX(gust_2) AS vitr_naraz #vezme se max sila vetru v dany den
	FROM pocasi
	GROUP BY city,date
)
SELECT 
 	poc.date,
	poc.city,
 	poc.country,
  	prum.Prum_den_tep,
 	CASE WHEN prs.kolik_hodin_prselo IS NULL THEN 0 #pokud sloupec kolik_hodin_prselo neobsahuje hodnotu (je NULL) zadej 0 - tzn. ten den neprselo
 	ELSE prs.kolik_hodin_prselo END AS kolik_h_prselo, #pokud je jina hodnota, tak tu dej do noveho sloupce kolik_h_prselo
  	v.vitr_naraz
FROM pocasi poc
LEFT JOIN prum_den_teplota prum
  	ON poc.date = prum.date
  	AND poc.city = prum.city
LEFT JOIN prsi prs 
 	ON poc.date = prs.date
 	AND poc.city = prs.city
LEFT JOIN vitr v
	ON poc.date = v.date
	AND poc.city = v.city
GROUP BY city,date;


CREATE TABLE t_jiri_drahotsky_projekt_SQL_final AS #vytvoreni vysledné tabulky
SELECT
	s.*,
 	w.Prum_den_tep,
	w.kolik_h_prselo,
	w.vitr_naraz
FROM staty s
LEFT JOIN weather_2 w
	ON s.country = w.country
	AND s.date = w.date;

-- Priklady pouziti
-- Vyber vsech sloupcu
SELECT * FROM t_jiri_drahotsky_projekt_SQL_final;


-- Vyber vsech sloupcu pouze pro Ceskou repbliku
SELECT
	*
FROM t_jiri_drahotsky_projekt_SQL_final
WHERE country = 'Czechia';

-- Nejvice nakazenych v jednotlivych zemi
SELECT
	country,
	MAX(confirmed) AS pocet_nejvice_nakazanych
FROM t_jiri_drahotsky_projekt_SQL_final
GROUP BY country
ORDER BY MAX(confirmed) DESC;

-- Nejvice provedenych testu v jednotlivych zemi
SELECT
	country,
	MAX(tests_performed) AS pocet_nejvice_provedenych_testu
FROM t_jiri_drahotsky_projekt_SQL_final
GROUP BY country
ORDER BY MAX(tests_performed) DESC;

#smazani vsech tabulek, ktere slouzily k vytvoreni finalni tabulky
DROP TABLE countries_2;
DROP TABLE covid_test;
DROP TABLE religions_2;
DROP TABLE life_exp_proj;
DROP TABLE zakladni;
DROP TABLE staty;
DROP TABLE pocasi;
DROP TABLE weather_2;


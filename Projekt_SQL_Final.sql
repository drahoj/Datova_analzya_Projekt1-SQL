-- Vytvoøení klonu tabulky countries - z dùvodu, aby se sjednotily názvy a bylo možné dìlat joiny
CREATE TABLE countries_2 AS
	SELECT
		*
	FROM countries

	
-- UPDATE tabulky countries_2 (úprava názvu hlavního mìsta vùèi tabulce weather)
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

-- UPDATE tabulky countries_2 (úprava názvu country vùèi tabulce covid19_basic_differences)
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

-- Vytvoøení klonu tabulky covid19_tests - z dùvodu, aby se sjednotily názvy a bylo možné dìlat joiny
CREATE TABLE covid_test
	SELECT
		* 
	FROM covid19_tests

-- UPDATE tabulky covid_test (úprava názvu country vùèi tabulce covid19_basic_differences)
UPDATE covid_test SET country = 'Burma' WHERE country = 'Myanmar';
UPDATE covid_test SET country = 'Congo (Kinshasa)' WHERE country = 'Democratic Republic of Congo';
UPDATE covid_test SET country = 'Czechia' WHERE country = 'Czech Republic';
UPDATE covid_test SET country = 'Korea, South' WHERE country = 'South Korea';
UPDATE covid_test SET country = 'Taiwan*' WHERE country = 'Taiwan';
UPDATE covid_test SET country = 'US' WHERE country = 'United States';


-- Pomocná tabulka, která slouží k vypoètu podílu jednotlivých náboženství
CREATE TABLE religions_2 AS
WITH relig as ( #doèasná tabulka, ze sloupce religion veme promìnné pro jednotlivé náboženství a dá je do samostatného sloupce
	SELECT
		*,
		MAX(CASE WHEN religion = 'Christianity' THEN population END) AS Religion_Christianity_1,#pokud je v !!!
		MAX(CASE WHEN religion = 'Islam' THEN population END) AS Religion_Islam_1,
		MAX(CASE WHEN religion = 'Unaffiliated Religions' THEN population END) AS Unaffiliiated_Religions_1,
		MAX(CASE WHEN religion = 'Hinduism' THEN population END) AS Religion_Hinduism_1,
		MAX(CASE WHEN religion = 'Buddhism' THEN population END) AS Religion_Buddhism_1,
		MAX(CASE WHEN religion = 'Folk Religions' THEN population END) AS Religion_Folk_Religions_1,
		MAX(CASE WHEN religion = 'Other Religions' THEN population END) AS Religion_Other_Religions_1,
		sum(population) as pop
	FROM religions
	WHERE year = 2020 #data se berou za rok 2020, je to nejblíže k roku v COVID tabulce
	GROUP BY country
)
	SELECT
		*,
		CASE WHEN Religion_Christianity_1 != 0 THEN round(Religion_Christianity_1/sum(pop)*100,1) #pokud hodnota v daném sloupci není nula, pak spoèítej procentuální velikost daného naboženství
			ELSE 0 END AS Religion_Christianity,
		CASE WHEN Religion_Islam_1 != 0 THEN round(Religion_Islam_1/sum(pop)*100,1) 
			ELSE 0 END AS Religion_Islam,
		CASE WHEN Unaffiliiated_Religions_1 != 0 THEN round(Unaffiliiated_Religions_1/sum(pop)*100,1) 
			ELSE 0 END AS Unaffiliiated_Religions,
		CASE WHEN Religion_Hinduism_1 != 0 THEN round(Religion_Hinduism_1/sum(pop)*100,1) 
			ELSE 0 END AS Religion_Hinduism,
		CASE WHEN Religion_Buddhism_1 != 0 THEN round(Religion_Buddhism_1/sum(pop)*100,1) 
			ELSE 0 END AS Religion_Buddhism,
		CASE WHEN Religion_Folk_Religions_1 != 0 THEN round(Religion_Folk_Religions_1/sum(pop)*100,1) 
			ELSE 0 END AS Religion_Folk_Religions,
		CASE WHEN Religion_Other_Religions_1 != 0 THEN round(Religion_Other_Religions_1/sum(pop)*100,1) 
			ELSE 0 END AS Religion_Other_Religions
	FROM relig
	GROUP BY country

	
CREATE TABLE life_exp_proj AS #pomocná tabulka pro výpoèet hodnoty - rozdíl mezi oèekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých probìhl rychlý rozvoj mohou reagovat jinak než zemì, které jsou vyspìlé už delší dobu
WITH jedna_1965 AS ( #pomocné tabulky pro hodnoty life_expectancy v roce 1965 a 2015
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
SELECT #odeètou se hodnoty ve dvou sloupcích a uložíé se do nového sloupce
	j.country,
	j.life_expectancy AS life_expectancy_1965,
	d.life_expectancy AS life_expectancy_2015,
	d.life_expectancy - j.life_expectancy AS rozdil
	FROM jedna_1965 j
	LEFT JOIN druha_2015 d
		ON j.country = d.country


		
 CREATE TABLE zakladni #vznikne spojením tabulek covid19_basic_differences a covid_test
 	SELECT				#doplní tabulku covid19_basic_differences o informace o poètu provedených testù
 		dif.date,
 		dif.country,
 		dif.confirmed,
 		test.tests_performed
 	FROM covid19_basic_differences dif
 	LEFT JOIN covid_test test
 		ON dif.country = test.country
 		AND dif.date = test.date




CREATE TABLE staty AS # tabulka pro výpoèet èasových promìnných a promìnných specifických pro daný stát
WITH GDP_5 AS ( #pomocna tabulka na vypocet HDP (GDP) a detskou umrtnost
	select
		country,
		GDP,
		round(GDP/population,2) as GDP_na_osobu, #výpoèet HDP na obyvatele - HDP/poètem obvytael zaukroulené na 2 desetinná místa
		mortaliy_under5 #-- Dìtská úmrtnost
	from economies e
	where year = '2019' #data braná z roku 2019, ve 2020 nebyla data dostupná
),
GINI_k as ( #pomocna tabulka na vypocet GINI koeficientu
	select distinct
		country,
		gini,
		year
	from economies
	where gini is not null #pro danou zemi se bere hodnota, která je nenulová (každá zemì mùže mít hodnotu z jiného roku)
	group by country
)
SELECT
	zak.*,
	c.population AS Pocet_obyvatel,
	case	
		when WEEKDAY(zak.date) <= 4 then "pracovní den" #urceni, zda dany den je pracovni nebo vikend
		else "víkend" end as pracovní_den_víkend, #funkce weekday vrati hodnotu dne v tydnu (0-4 pracovni dny, 5 a 6 vikend)
	case when month(zak.date) in (12, 1, 2) then '0' #ZIMA (prosinec, leden, unor) #urceni rocniho odbodbi, fce month vrati hodnotu mesice v roce (1 az 12)
      	when month(zak.date) in (3, 4, 5) then '1' #jaro (brezen, duben, kveten)
      	when month(zak.date) in (6, 7, 8) then '2' #leto (cerven, cervenec, srpen)
      	when month(zak.date) in (9, 10, 11) then '3' #podzim (zari, rijen, listopad)
 	  	end as rocni_odbobi,
 	c.population_density, #hustota zalidnìní
 	g.GDP_na_osobu, #HDP na obyvatele
  	gi.gini, #GINI koeficient 
  	g.mortaliy_under5, # Dìtská úmrtnost
  	c.median_age_2018, #medián vìku obyvatel v roce 2018
  	rel.Religion_Christianity, #podíly jednotlivých náboženství
  	rel.Religion_Islam,
  	rel.Unaffiliiated_Religions,
  	rel.Religion_Hinduism,
  	rel.Religion_Buddhism,
  	rel.Religion_Folk_Religions AS Folk_Religions,
  	rel.Religion_Other_Religions AS Other_Religions,
  	lif.rozdil as Rozdil_Life_expect #rozdíl mezi oèekávanou dobou dožití v roce 1965 a v roce 2015
FROM zakladni zak
left join countries_2 c
on zak.country = c.country
left join GDP_5 AS g
on zak.country = g.country
left join GINI_K gi
on zak.country = gi.country
left join religions_2 rel
on zak.country = rel.country
left join life_exp_proj lif
on zak.country = lif.country



-- Poèasí (ovlivòuje chování lidí a také schopnost šíøení viru) 
CREATE TABLE pocasi AS #pomocná tabulka pro vypocet a vytvoreni view pro vsechny promenne v ramci pocasi
 	SELECT
		w.*,
		c.country,
		CAST (TRIM (TRAILING 'km/h' FROM w.gust) as integer) as gust_2, #odtraneni km/h z hodnoty sloupce gust, prevod na integer a zapis do noveho sloupce gust_2
		CAST (TRIM (TRAILING ' °c' from temp) as integer) as temp_2
		FROM weather w 
	LEFT JOIN  countries_2 c
		ON w.city = c.capital_city
 	WHERE date >= '2020-01-22' AND city is not null
 

 	
CREATE TABLE weather_2 AS # vytvoreni tabulky, ktere bude obsahovat vsechny pozadovane promenne z oblasti pocasi
   WITH prum_den_teplota AS (
  	SELECT					
 		date,					
 		city,
 		country,
 		avg(temp_2) AS Prum_den_tep #prumerna denni teplota
 	FROM pocasi
 	WHERE time in ('06:00','09:00','12:00','15:00','18:00') #teplota se vypoèítá jen z denních hodnot, tj od 6 do 18h 
   	GROUP BY city,date
   ),
prsi AS (  #zjisteni, kolik hodin za den prselo
	SELECT
		date,
		city,
		country,
		count(time)*3 AS kolik_hodin_prselo #zjistí se, v kolika denních blocích pršelo a vynásbí se 3, aby se to pøevedlo na hodiny (jeden blok=3 hodiny)
	FROM pocasi
	WHERE rain > '0.0 mm' #jen když prší
	GROUP BY city,date
),
vitr as (
	SELECT
		date,
		city,
		country,
 		MAX(gust_2) as vitr_naraz #vezme se max síla vìtru v daný den
	FROM pocasi
	GROUP BY city,date
)
SELECT 
 	poc.date,
	poc.city,
 	poc.country,
  	prum.Prum_den_tep,
 	CASE WHEN prs.kolik_hodin_prselo is null then 0 #pokud sloupec kolik_hodin_prselo neobsahuje hodnotu (je NULL) zadej 0 - tzn. ten den neprselo
 	ELSE prs.kolik_hodin_prselo END AS kolik_h_prselo, #pokd je jina hodnota, tak tu dej do noveho sloupce kolik_h_prselo
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
GROUP BY city,date


CREATE TABLE t_jiri_drahotsky_projekt_SQL_final as #vytvoøení výsledné tabulky
SELECT
	s.*,
 	w.Prum_den_tep,
	w.kolik_h_prselo,
	w.vitr_naraz
FROM staty s
LEFT JOIN weather_2 w
	ON s.country = w.country
	AND s.date = w.date
	
select * from t_jiri_drahotsky_projekt_SQL_final
where country = "Czechia"


drop TABLE countries_2;
Drop TABLE covid_test;
drop TABLE religions_2;
DROP TABLE life_exp_proj;
DROP TABLE zakladni;
DROP TABLE staty;
DROP TABLE pocasi;
DROP table weather_2;
DROP table t_jiri_drahotsky_projekt_SQL_final

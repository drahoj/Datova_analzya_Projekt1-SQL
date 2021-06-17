SELECT
	covid.*,
	case	
		when WEEKDAY(covid.date) <= 4 then "pracovní den" 
		else "víkend" end as binární_promìnná_pro_víkend_pracovní_den,
	case when month(covid.date) in (12, 1, 2) then '0' #ZIMA
      when month(covid.date) in (3, 4, 5) then '1' #jaro
      when month(covid.date) in (6, 7, 8) then '2' #leto
      when month(covid.date) in (9, 10, 11) then '3' #podzim
 	  end as rocni_odbobi,
 	 c.population_density
FROM covid19_basic_differences covid
left join countries c
on covid.country = c.country
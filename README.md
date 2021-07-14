Projekt SQL

V rámci tohoto projektu bylo cílem vytvořit tabulku, která bude obsahovat všechna potřebná data pro vyhodnocení modelu, který bude vysvětlovat denní nárůsty nárůsty nakažených v jednotlivých zemích. Tabulka obsahuje data o počtu provedených testů a počtu obyvatel daného státu. Na základě těchto tří proměnných je potom možné vytvořit vhodnou vysvětlovanou proměnnou. Denní počty nakažených je možné vysvětlovat pomocí proměnných několika typů. Každý sloupec v tabulce představuje jednu proměnnou:

    Časové proměnné
        - binární proměnná pro víkend / pracovní den
        - roční období daného dne (zakódujte prosím jako 0 až 3)
    Proměnné specifické pro daný stát
        - hustota zalidnění - ve státech s vyšší hustotou zalidnění se nákaza může šířit rychleji
        - HDP na obyvatele - použijeme jako indikátor ekonomické vyspělosti státu
        - GINI koeficient - má majetková nerovnost vliv na šíření koronaviru
        - dětská úmrtnost - použijeme jako indikátor kvality zdravotnictví
        - medián věku obyvatel v roce 2018 - státy se starším obyvatelstvem mohou být postiženy více
        - podíly jednotlivých náboženství - použijeme jako proxy proměnnou pro kulturní specifika. Pro každé
          náboženství v daném státě bych chtěl procentní podíl jeho příslušníků na celkovém obyvatelstvu
        - rozdíl mezi očekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých proběhl rychlý
          rozvoj mohou reagovat jinak než země, které jsou vyspělé už delší dobu
    Počasí (ovlivňuje chování lidí a také schopnost šíření viru)
        - průměrná denní (nikoli noční!) teplota
        - počet hodin v daném dni, kdy byly srážky nenulové
        - maximální síla větru v nárazech během dne


Tabulka vznikla sloučením několika tabulek. V tabulce je možné vyhledávat pomocí SQL doatzů jednotlivé proměnné pro definované státy v požadovaných časových období.

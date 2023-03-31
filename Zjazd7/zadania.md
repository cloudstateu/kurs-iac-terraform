# Zadania Domowe Szkolenie Terraform: Zjazd 6

Zadania z tego zestawu wykonaj w nowej konfiguracji Terraform, nie będą one wykorzystywane w projekcie z poprzednich
dwóch zjazdów.

## Zadanie 1 - Multiple Provider Configurations

W ramach tego zadania wykorzystaj kod Terraform z zadania 1 z zjazdu 4, jeśli nie wykonałeś tego zadania, możesz
skorzystać z gotowego rozwiązania.

Celem zadania jest przerobienie konfiguracji Hub & Spoke, tak aby:

* Wszystkie zasoby dotyczące "Hub" były utworzone w jednej subskrypcji
* Wszystkie zasoby dotyczące "Spoke" były utworzone w innej subskrypcji niż "Hub"

Do wykonania tego zadania będziesz musiał przygotować kolejnego providera AzureRM i skonfigurować go tak by korzystał z
innej subskrypcji. Dodatkowo trzeba będzie też pobrać przy pomocy `data` kolejną grupę zasobów z nowej subskrypcji.

Po zmianach przetestuj, czy Twój kod nadal działa i wszystko poprawnie się tworzy.

Na co warto zwrócić uwagę:

* Nie korzystaj z providera default, ustaw alias dla każdego providera AzureRM.
* Przy każdym zdefiniowanym zasobie (`data` oraz `resource`) musi być wskazany odpowiedni provider.
* Pamiętaj, że dany provider działa tylko w zakresie jednej subskrypcji.
* Jeśli zmienisz alias, gdy zasoby już istnieją Terraform może je "zgubić", dlatego usuń zasoby przed zmianami.

Pomocne linki:

* [Dokumentacja na temat aliasowania providerów](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)

## Zadanie 2 - Spoke Module

W ramach tego zadania wydziel kod rozstawiający sieć spoke do osobnego modułu.
Moduł powinien także tworzyć dwustronny peering pomiędzy siecią Spoke a Hub.
W module zdefiniuj odpowiednie zmienne, dodaj też `output`, które będą zawierały identyfikator utworzonej sieci i
wszystkich podsieci.

Po przygotowaniu modułu spróbuj za jego pomocą utworzyć trzy różne sieci Spoke (możesz spróbować wykorzystać for_each),
dodaj też output, który wyświetli identyfikatory wszystkich utworzonych sieci. Sprawdź, czy zasoby są tworzone
poprawnie.

Na co warto zwrócić uwagę:

* Zadbaj o przygotowanie odpowiednim zmiennych, powinny one umożliwiać wielokrotne wykorzystanie modułu.
* Konfiguracja aliasów providerów wewnątrz modułu różni się od zwykłej konfiguracji.
* Output wewnątrz modułu służy do wynoszenia informacji poza moduł, aby wyświetlić output, musisz dodatkowo umieścić go
  w konfiguracji wywołującej moduł.

Pomocne linki:

* [Dokumentacja na temat modułów w Terraform](https://developer.hashicorp.com/terraform/language/modules/develop)
* [Aliasowanie providerów w ramach modułu](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)

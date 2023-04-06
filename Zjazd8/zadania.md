# Zadania Domowe Szkolenie Terraform: Zjazd 7

W ramach tego zestawu zadań będziemy kontynuować pracę nad projektem.

## Zadanie 1 - Provider Aliases

W ramach tego zadania uzupełnij kod projektu o aliasy providerów.

W części Shared wykorzystywany będzie tylko jeden provider, a w części aplikacyjnej wykorzystywane będą dwa providery
AzureRM (Shared + App).
Po wprowadzeniu zmian przetestuj utworzenie części aplikacyjnej na innej subskrypcji.

Na co warto zwrócić uwagę:

* Jeśli wykorzystujemy aliasy, warto zrezygnować z domyślnego providera i stosować je przy każdym zasobie. Poprawi to
  czytelność kodu i ułatwi dodawanie kolejnych zasobów.
* Dodanie aliasów powinno umożliwić tworzenie zasobów pod aplikacje w innej subskrypcji.
* Dodaj kolejną grupę zasobów pobieraną przy pomocy Data dla zasobów Shared.

Pomocne linki:
* [Dokumentacja na temat aliasowania providerów](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)

## Zadanie 2 - Key Vault Module

W ramach tego zadania wydziel kod dotyczący zasobu Key Vault do osobnego modułu.
Po przygotowaniu modułu zastąp wszystkie zasoby dotyczące Key Vault wywołaniem modułu, do migracji wykorzystaj
blok `moved`. W ramach zadania nie musisz umożliwiać konfiguracji wszystkich parametrów zasobów.

Moduł powinien zawierać:

* Tworzenie Key Vault.
* Tworzenie access policy w ramach Key Vault zgodnie z przekazanymi zmiennymi.
* Tworzenie prywatnego endpointu.
* Odpowiednie zmienne wejściowe i wyjściowe.
* Zdefiniowany alias dla providera Azure.

Opcjonalnie możesz dodać tworzenie prywatnej strefy DNS, możesz oczekiwać przekazania jej poprzez zmienne.
Dodatkowo możesz spróbować wygenerować dokumentację modułu przy pomocy Terraform Docs.

Pomocne linki:
* [Dokumentacja na temat modułów w Terraform](https://developer.hashicorp.com/terraform/language/modules/develop)
* [Aliasowanie providerów w ramach modułu](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
* [Dokumentacja Terraform Docs](https://terraform-docs.io/)

## Zadanie 3 - AKS Module

W ramach tego zadania wydziel kod dotyczący zasobu Azure Kubernetes Service do osobnego modułu.
Po przygotowaniu modułu zastąp wszystkie zasoby dotyczące AKS wywołaniem modułu, do migracji wykorzystaj blok `moved`.
W ramach zadania nie musisz umożliwiać konfiguracji wszystkich parametrów zasobów.

Moduł powinien zawierać:

* Tworzenie `azurerm_user_assigned_identity` wykorzystywanych przez klaster.
* Przypisanie odpowiednich uprawnień do tożsamości.
* Tworzenie klastra oraz node pool.
* Odpowiednie zmienne wejściowe i wyjścia.
* Definicje dwóch aliasów providerów (Shared, App).

Opcjonalnie możesz dodać tworzenie prywatnej strefy DNS, możesz oczekiwać przekazania jej poprzez zmienne.
Dodatkowo możesz spróbować wygenerować dokumentację modułu przy pomocy Terraform Docs.

Pomocne linki:
* [Dokumentacja na temat modułów w Terraform](https://developer.hashicorp.com/terraform/language/modules/develop)
* [Aliasowanie providerów w ramach modułu](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
* [Dokumentacja Terraform Docs](https://terraform-docs.io/)

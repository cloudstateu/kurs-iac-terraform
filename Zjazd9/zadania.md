# Zadania Domowe Szkolenie Terraform: Zjazd 9

## Zadanie 1 - Refaktoryzacja

W ramach tego zadania wykonaj refaktoryzację kodu projektu m.in.:

* Zaktualizuj wersję Terraform do najnowszej.
* Zaktualizuj wersję providerów do najnowszych.
* Zastąp przestarzałe parametry zasobów nowymi.
* Spróbuj wykorzystać data `terraform_remote_state` do pobierania danych zasobów Shared.

Na co warto zwrócić uwagę:

* W części Shared zdefiniuj wymagane outputy, aby wykorzystać je przy pomocy data `terraform_remote_state`.

Pomocne linki:

* [Dokumentacja na temat data terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)

## Zadanie 2 - PostgreSQL Module

W ramach tego zadania wydziel kod dotyczący zasobu Azure Database for PostgreSQL do osobnego modułu.

Po przygotowaniu modułu zastąp wszystkie zasoby dotyczące PostgreSQL wywołaniem modułu, do migracji wykorzystaj
blok `moved`.

W ramach zadania nie musisz umożliwiać konfiguracji wszystkich parametrów zasobów.

Moduł powinien zawierać:

* Tworzenie serwera bazy danych PostgreSQL.
* Tworzenie bazy danych na serwerze PostgreSQL z wykorzystaniem `for_each`.
* Automatyczne generowanie hasła do bazy danych, jeśli nie zostało przekazane poprzez zmienną.
* Odpowiednie zmienne wejściowe i wyjściowe.
* Zdefiniowany alias dla providera Azure.

Opcjonalnie możesz dodać tworzenie prywatnej strefy DNS, możesz oczekiwać przekazania jej poprzez zmienne.
Dodatkowo możesz spróbować wygenerować dokumentację modułu przy pomocy Terraform Docs.

Pomocne linki:
* [Dokumentacja zasobu azurerm_postgresql_flexible_server_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database)
* [Dokumentacja na temat modułów w Terraform](https://developer.hashicorp.com/terraform/language/modules/develop)
* [Aliasowanie providerów w ramach modułu](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
* [Dokumentacja Terraform Docs](https://terraform-docs.io/)

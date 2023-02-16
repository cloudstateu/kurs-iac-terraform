# Szkolenie Terraform: Zjazd 1

## Zadanie 1

Celem tego zadania laboratoryjnego jest nauczenie się konfigurowania providera AzureRM oraz pobierania istniejących
zasobów przy pomocy Data w chmurze Azure.

W ramach zadania należy skonfigurować providera AzureRM oraz pobrać istniejącą grupę zasobów o nazwie chm-studentXX (
gdzie XX to Twój numer studenta).

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Zaloguj się do przypisanego do Ciebie konta Azure przy pomocy komendy `az login`.
2. Utwórz plik `providers.tf` i skonfiguruj w nim providera AzureRM. Zwróć uwagę, aby w konfiguracji providera wskazać
   odpowiednie ID Subskrypcji, na której będzie znajdować się pobierana grupa zasobów.
3. Wykonaj inicjalizację konfiguracji przy pomocy komendy `terraform init`.
4. Utwórz plik `data.tf` i dodaj w nim blok Data typu `azurerm_resource_group`. Skonfiguruj go zgodnie z dokumentacją,
   tak aby pobrać wymaganą grupę zasobów.
5. Uruchom polecenie `terraform plan`, aby sprawdzić, czy Terraform wykrył grupę zasobów i czy nie ma błędów w
   konfiguracji.
6. Uruchom polecenie `terraform apply`. Terraform pobierze istniejącą grupę zasobów z Azure, zapisze ją w stanie i
   zakończy działanie bez wprowadzania żadnych zmian.
7. Sprawdź, co zostało zapisane w pliku stanu po uruchomieniu polecenia `terraform apply`.

Pomocne linki:

* [Dokumentacja providera AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Data azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)

## Zadanie 2

Celem tego zadania jest nauczenie się tworzenia zasobów w chmurze Azure przy użyciu Terraform.

W ramach zadania należy dodać do konfiguracji z poprzedniego zadania tworzenie nowego zasobu Azure Key Vault w pobranej
przy pomocy Data grupie zasobów.
Podczas konfiguracji zasobu Azure Key Vault nadaj uprawnienia swojemu użytkownikowi do pobierania i tworzenia sekretów.

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Do pliku `data.tf` dodaj nowy blok data typu `azurerm_client_config`. Zawiera on informacje na temat aktualnie
   skonfigurowanego klienta w providerze. W naszym przypadku będzie to aktualnie zalogowany użytkownik.
2. W nowo utworzonym pliku skonfiguruj blok zasobu dla usługi Azure Key Vault. Podczas
   konfigurowania zasobu wykorzystaj w odpowiednich parametrach referencje do pobieranej grupy zasobów. W
   bloku `access_policy` skonfiguruj uprawnienia dla swojego użytkownika.
3. Uruchom polecenie `terraform plan`. Sprawdź, czy Terraform wykrył błędy w konfiguracji. Zwróć uwagę na wynik planu,
   Terraform powinien zwrócić, że utworzy jeden nowy zasób.
4. Uruchom polecenie `terraform apply`, aby wdrożyć zasób Azure Key Vault.
5. Zweryfikuj, czy utworzenie zasobu przebiegło pomyślnie przez wyszukanie zasobu w portalu Azure.
6. Sprawdź, jakie zmiany powstały w pliku stanu, zwróć uwagę na różnice pomiędzy `data` a `resource`.

Pomocne linki:

* [Zasób azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)
* [Data azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)

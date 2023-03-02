# Zadania Domowe Szkolenie Terraform: Zjazd 3

## Zadanie 1

Celem tego zadania jest nauczenie się wykorzystania pętli count.

W ramach tego zadania należy utworzyć nową zmienną lokalną `passwords` typu `list(string)`.
Dodaj do listy co najmniej dwa przykładowe hasła.
Następnie przy pomocy `azurerm_key_vault_secret` i `count` utworzyć sekrety w Azure Key Vault.

Przykład zmiennej lokalnej typu `list(string)`:

```terraform
locals {
  passwords = [
    "secretvalue123",
    "secretvalue321"
  ]
}
```

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Utwórz nowy plik `variables.tf` i utwórz w nim nową zmienną lokalną o nazwie `passwords`.
2. Dodaj nowy zasób typu `azurerm_key_vault_secret`. Podczas konfiguracji wykorzystaj `count` i zadbać o unikalność nazw
   tworzonych sekretów, wartość sekretu pobierz ze zmiennej lokalnej. Pamiętaj, że przy wykorzystaniu `count` masz
   dostęp do słowa kluczowego `count` przy pomocy którego możesz odwołać się konkretnej iteracji np. `count.index`.
3. Uruchom polecenie `terraform plan`. Sprawdź, czy Terraform wykrył błędy w konfiguracji.
4. Uruchom polecenie `terraform apply`, aby utworzyć sekret.
5. Zweryfikuj, czy utworzenie sekretu przebiegło pomyślnie przez jego wyszukanie w Azure Key Vault.
6. Dodaj kolejne hasła do zmiennej lokalnej np. na początku listy, na końcu i na środku. Uruchom ponownie
   polecenie `terraform plan` i sprawdź, jak zachowa się Terraform wobec aktualnie istniejących sekretów.
7. Sprawdź jak przedstawiony jest zasób wykorzystujący `count` w pliku stanu.

Po zakończeniu zadania usuń utworzone sekrety i zmienną lokalną, nie będą one wykorzystywane w dalszych zadaniach.

Pomocne linki:

* [Zasób azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret)
* [Pętla count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

## Zadanie 2

Celem tego zadania jest nauczenie się importowania zasobów do stanu.

W ramach tego zadania należy utworzyć zasób Storage Account ręcznie w Azure, przygotować kod Terraform reprezentujący
dany zasób i zaimportować zasób do stanu przy pomocy polecenia `terraform import`.

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Utwórz zasób Storage Account w portalu Azure.
2. Przygotuj reprezentacje storage account w pliku Terraform.
3. Zaimportuj utworzony zasób przy pomocy polecenia `terraform import`.
4. Sprawdź zmiany w pliku stanu po zaimportowaniu zasobu.
5. Uruchom polecenie `terraform plan` w celu sprawdzenia zgodności opisanego zasobu ze znajdującym się w chmurze.

Po zakończeniu zadania usuń utworzony storage account.

Pomoce linki:
* [Zasób azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [Polecenie terraform import](https://developer.hashicorp.com/terraform/cli/commands/import)

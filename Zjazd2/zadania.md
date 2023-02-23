# Zadania Domowe Szkolenie Terraform: Zjazd 2

Zadanie 1 wykonaj w nowej konfiguracji Terraform.

## Zadanie 1

Celem tego zadania jest nauczenie się korzystania ze zmiennych.

W ramach tego zadania należy stworzyć sieć wirtualną i podsieć przy pomocy zasobów `azurerm_virtual_network` oraz `azurerm_subnet`.
Nazwy zasobów i zakresy sieciowe sieci/podsieci umieść w zmiennych.
Wykorzystaj zmienną lokalną do wymuszenia prefixu w nazwach zasobów z Twoim numerem studenta.
Zasoby umieść w przygotowanej dla Ciebie grupie zasobów (będzie tu potrzebna data source).

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Utwórz nowy folder i skonfiguruj w nim providera AzureRM.
2. Utwórz plik `data.tf` i umieść w nim data source reprezentujący Twoją grupę zasobów `azurerm_resource_group`.
3. Utwórz plik `variables.tf` i zdefiniuj w nim zmienne: `vnet_name`, `subnet_name`, `vnet_address_space` i `subnet_address_prefixes`.
4. Dodaj do pliku `variables.tf`, zmienne lokalne, które do nazwy podanej w zwykłych zmiennych dodadzą prefix.
5. Utwórz plik `network.tf` i dodaj do niego zasoby `azurerm_virtual_network` i `azurerm_subnet`, skonfiguruj je z wykorzystaniem zmiennych i zmiennych lokalnych.
6. Utwórz plik `terraform.tfvars` i przypisz wartości do zmiennej.
7. Uruchom polecenie `terraform plan`. Sprawdź, czy Terraform wykrył błędy w konfiguracji.
8. Spróbuj przekazać wartość zmiennej do konfiguracji Terraform na inne sposoby np. z poziomu opcji CLI -var, zmiennych
   środowiskowych TF_VAR_. Spróbuj przekazać wartość na kilka sposób jednocześnie i sprawdź efekt.


Pomocne linki:

* [Zasób azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Zasób azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [Zmienne w terraform](https://developer.hashicorp.com/terraform/language/values/variables)
* [Pierwszeństwo definicji zmiennych](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)


## Zadanie 2

Resztę zadań wykonaj w konfiguracji utworzonej w zadaniach z zjazdu pierwszego.

Celem tego zadania jest nauczenie się wykorzystywania pętli for_each.

W ramach tego zadania należy utworzyć zmienną lokalną `password` typu `map(string)`.
Dodaj do listy co najmniej dwa przykładowe hasła.
Następnie przy pomocy `azurerm_key_vault_secret` i `for_each` utworzyć sekrety w Azure Key Vault.

Przykład zmiennej lokalnej typu `map(string)`:

```terraform
locals {
  passwords = {
    secret1 = "secretvalue123"
    secret2 = "secretvalue321"
  }
}
```

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Dodaj zmienną lokalną o nazwie `passwords` typu `map(string)` w pliku `variables.tf`.
2. Dodaj nowy zasób typu `azurerm_key_vault_secret`. Podczas konfiguracji wykorzystaj `for_each` i zadbać o unikalność nazw
   tworzonych sekretów, wartość sekretu pobierz ze zmiennej lokalnej. Klucz w mapie powinien zostać przekazany jako nazwa
   sekretu, a wartość danego wpisu w mapie jako wartość sekretu.
3. Uruchom polecenie `terraform plan`. Sprawdź, czy Terraform wykrył błędy w konfiguracji.
4. Uruchom polecenie `terraform apply`, aby utworzyć sekret.
5. Zweryfikuj, czy utworzenie sekretów przebiegło pomyślnie przez ich wyszukanie w Azure Key Vault.
6. Spróbuj dodać kolejne sekrety do zmiennej lokalnej i uruchomić ponownie polecenia `terraform plan` i
   `terraform apply`. Zwróć uwagę na różnice w zachowaniu Terraform w porównaniu do pętli `count`. Spróbuj dodać kolejne
   wpisy do mapy w różnych miejscach tzn. na początku, w środku i na końcu mapy.
7. Sprawdź jak przedstawiony jest zasób wykorzystujący `for_each` w pliku stanu.

Po zakończeniu zadania usuń utworzone sekrety i zmienną lokalną, nie będą one wykorzystywane w dalszych zadaniach.

Pomocne linki:

* [Zasób azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret)
* [Pętla for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)


## Zadanie 3

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

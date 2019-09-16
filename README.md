# Coleta de Inventário

Aplicativo para coleta de inventário da UFRGS.

## Começando

Para clonar o repositório, escolha o link HTTPS e não o SSH (onde aparece SSH é só clicar que muda para o HTTPS).

### Pré-requisitos

Para gerenciamento de bibliotecas, foi utilizado CocoaPods.
Caso CocoaPods não esteja instalado, usar o seguinte comando:

```
$ sudo gem install cocoapods
```
### Sobre o projeto (XCode)

Sempre abrir o projeto com o arquivo `Inventário UFRGS.workspace` pois o mesmo contém todos os links de bibliotecas e pods. Quando o projeto é aberto com `Inventário UFRGS.xcodeproj` ele não será executável.


### Melhorias solicitação para o aplicativo coleta de inventário:

- [x] ~~Buscar prédio também por código semântico (será retornado na API)~~
- [x] Listar inicialmente todos os espaços físicos do prédio, permitindo filtrar
	- [ ] Será analisada a possibilidade de restringir os espaços físicos por órgão
- [x] ~~Se pesquisar um número que não retorne informações (Internal Server Error), emitir um aviso "Bem não tem tegistro (NTR)"~~
- [x] ~~Trazer em branco o estado de conservação - obrigar escolha~~
- [ ] Estados de conservação terão descritivos vinculados, que deverão ser mostrados na interface (será retornado pela API, mas está dependendo de alteração no BD)
- [x] ~~Inserir um campo para marcar se o bem está ocioso~~ (**OBS.: falta salvar na API - campo IndicadorOcioso**)
- [x] ~~Antes do nome do responsável, mostrar o nome do "Órgão responsável" pelo bem~~
- [x] ~~Emitir um aviso se o bem pesquisado (digitado ou lido) não pertence ao órgão de referência selecionado inicialmente~~
- [x] ~~Adicionar um novo botão, cinza, para registro de "Bem NTR"~~
	- [x] ~~A tela é a mesma dos dados de um bem existente, mas os campos devem vir todos em branco~~ e não ter campo para número de patrimônio (**OBS.: campo cinzado**)
	- [ ] Deve incluir automaticamente uma pendência tipo NTR
- [x] ~~Adicionar um novo botão, cinza, para registro de "Bem Sem Placa"~~ (**OBS.: API deve aceitar post com nrPatrimonio nulo**)
	- [x] ~~A tela é a mesma dos dados de um bem existente, mas os campos devem vir todos em branco~~ e não ter campo para número de patrimônio (**OBS.: campo cinzado?**)
	- [x] ~~Deve abrir para seleção as pendências de códigos 9, 5 e 1 e obrigar marcar uma delas:~~
		- [ ] Bem Sem Cadastro a Resolver (**OBS.: pendência código 9 não vem da API**)
		- [x] Bem Sem Cadastro com Documentação Localizada
		- [x] Marca de Placa Caída (MPC)

Alterações solicitadas na reunião de 20/08/2018:

- [x] ~~Quando o bem não tiver registro, deve abrir direto a tela de bem NTR. O número do patrimônio digitado deve ser recarregado e preenchido automaticamente a partir do que o usuário já havia digitado na tela anterior. Com essa implementação feita, pode-se remover o botão "BEM NTR" da página inicial~~
	- [x] ~~Na tela de bem NTR deixar disponível somente a pendência "Alterar descrição padronizada"~~
- [x] ~~Trocar rótulo "Nome" por "Descrição padronizada"~~
- [x] ~~Remover campo "Observação da situação~~

Tarefas que possivelmente precisam de alteração na API (28/08/18):
- [x] ~~NTR e Sem Placa deve pegar o diretor do órgão selecionado (atualmente traz o usuário que está logado)
	`v1/orgao/direcao/{codOrgao}`~~

- [x] ~~Buscar co-responsável tanto pelo cartão como pelo nome. Precisa de uma tela de confirmação/seleção do usuário.~~

- [x] ~~Bem NTR deve ter 2 pendências obrigatórias: "Bem NTR" e "Alterar descrição padronizada"~~

## Bibliotecas utilizadas

* `Alamofire`, `~> 4.0`
	* https://github.com/Alamofire/Alamofire
	* Serviços de API rest

* `SwiftyJSON`
	* https://github.com/SwiftyJSON/SwiftyJSON
	* Tratamento de arquivos JSON recebidos da API

* `SwiftOverlays`, `~> 3.0.0`
	* https://github.com/peterprokop/SwiftOverlays
	* Mostrar popups de carregamento

* `BarcodeScanner`, `2.1.2`
	* https://github.com/hyperoslo/BarcodeScanner
	* Leitura do código de barras dos patrimônios.


### Em caso de dúvidas

* Lucas Flores
* lsflores@inf.ufrgs.br

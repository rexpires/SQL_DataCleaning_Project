![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/1a4b9e95-22f8-471d-adae-ec9a1c3a0324)
# Projeto Limpeza e Transformação de Dados com SQL

Neste projeto realizo diversas consultas com SQL com o intuito de limpar e transformar alguns dados da base de dados chamada "Data Cleaning Project DB". O passo a passo foi o seguinte:

1  Padronizar formato de data;

2  Preencher dados nulos em "Property Address";

3  Quebrar "OwnerAddress" e "PropertyAddress" em colunas individuais (address, city, state);

4  Mudar Y ou N para Yes e NO no campo "Sold as Vacant";

5  Remover valores duplicados;

6  Deletar colunas não usadas.

-----------------------------------------------------------------------------------------------------

## Detalhamento:

1  Padronizar formato de data.

Iniciando com um "SELECT" de toda a tabela "NashvilleHousing", para verificação dos dados como um todo:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/d81b514f-618d-41f8-b798-2f1114207a9a)

Nota-se que a coluna "SaleDate" conta com dados no formato "DATETIME". Para facilitar possíveis consultas e análise dessa coluna, é necessário alterar o formato para "DATE":

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/327a4d7b-be8c-4820-86b8-36ecafc73508)

Portanto criei uma nova coluna "SalesDateConverted" (formato Date), utilizei o "ALTER TABLE" e "ADD" para adicioná-la na tabela e fiz um "UPDATE SET" com esse novo formato (Date). A partir de agora, podemos utilizar a coluna "SalesDateConverted" para consultarmos a data:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/fd18f557-d0c2-402a-86ab-957b8d1ef2b2)

-----------------------------------------------------------------------------------------------------
2  Preencher dados nulos em "Property Address".

O endereço é um dado importante para o negócio e não deve estar em branco.

Ao fazermos uma busca por valores nulos utilizando "WHERE Property Address is null" na coluna "Property Address", encontramos o seguinte:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/5324b63d-7967-4a50-b2bc-c444b3b92f46)

Analisando os dados, nota-se que quando os valores da coluna "ParcelID" são iguais, os valores de "Property Address" também são iguais, estabelecendo uma correlação entre eles:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/71f82309-080b-42f7-a47d-ec6a8db2471e)

Portanto a ideia foi fazer um "JOIN" da tabela com a própria tabela (criando as tabelas "NashvilleHousing" a e b), igualando os "ParcelID" e diferenciando os "UniqueID", resultando no seguinte:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/7c27baaa-989e-4213-aab0-9f2f5df267ae)

Fiz um "UPDATE" na tabela "a", estabelecendo que onde houver valores nulos em "Property Address" os mesmo devem ser preenchidos com os valores de endereço da "b". 29 linhas foram modificadas:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/9acd90d5-8946-491a-8f9a-f7ced0136277)

Rodando a penúltima query novamente ("SELECT"), nenhum resultado é encontrado, mostrando que atualização anterior foi bem sucedida:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/3d5a246b-0e82-4774-860c-e85f4e6d409c)

-----------------------------------------------------------------------------------------------------
3  Quebrar "OwnerAddress" e "PropertyAddress" em colunas individuais (address, city, state).

Selecionando as colunas "Property Address" e "Owner Address" encontramos o endereço completo, endereço, cidade e estado, o que acaba dificultando uma análise mais aprimorada desses dados.

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/05531990-6b31-4a2f-970c-e870c7d58b65)

A solucionar que encontrei para o problema foi trocar o delimitador de dados ‘,’ por ‘.’ para que a função "PARSENAME" possa reconhecer cada objeto corretamente:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/97c7db43-29ba-4363-86a1-81bf30476e7c)

Criei e atualizei as novas colunas "PropertySplitAddress" e "PropertyCityAddress":

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/e79b17e6-c913-4ee3-946b-0cb255e59039)

E também criei e atualizei as novas colunas "OwnerSplitAddress", "OwnerSplitCity" e "OwnerSplitState":

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/9d8d6049-c507-4d4f-bd9d-86c065f276fd)

-----------------------------------------------------------------------------------------------------
4  Mudar Y ou N para Yes e NO no campo "Sold as Vacant".

Na coluna "SoldAsVacant" encontrei os dados "Y", "N", "Yes" e "No". Apesar de compreender que "N" e "No" são a mesma coisa, por exemplo, é interessante realizar a padronização dos dados para o mesmo valor.
Utilizando o "COUNT" notei que "Yes" e "No"  estão em maior quantidade:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/bec62bb6-e0ba-4983-8c0c-9b504bfd3820)

Portanto transformarei os "Y" e "N" em "Yes" e "No":

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/6a432ab7-d914-41e7-9269-b546060c86cc)

"UPDATE" dos valores transformados:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/07a05d59-7086-4025-95f3-bcf5a671d58d)

Resultado: valores padronizados:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/5582aa32-7c0a-4d12-9e80-2bd609f6085a)

-----------------------------------------------------------------------------------------------------
5  Remover valores duplicados.

Utilizando o "ROW_NUMBER()" e "PARTITION BY" de colunas importantes, encontrei linhas que eram exatamente iguais, sendo que é possível identificá-la pelo índice 2 da coluna criada "row_num" ao final da tabela:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/dd541eb9-ebe2-4875-ab56-bd41100218e0)

A ideia aqui foi criar uma "CTE" chamada "RowNumCTE" para que depois eu filtrasse as linhas com "row_num" > 1, ou seja, que estivessem duplicadas:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/d012eae1-3078-4d1d-bd01-cd5b7067ccc2)

Deletei as linhas duplicadas:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/83403333-bc8a-4180-bfb9-f93f50ad94ed)

Não há mais valores duplicados:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/6118883e-6bcd-4425-bcac-1ae160050713)

-----------------------------------------------------------------------------------------------------
6  Deletar colunas não usadas.

As colunas que alterei nos tópicos anteriores "SaleDate", "PropertyAddress", "OwnerAddress" e "TaxDistinct" (esta última não modifiquei, mas entendo que não necessitaria dela em uma análise) devem ser deletadas, pois não têm mais utilidade, portanto:

![image](https://github.com/rexpires/SQL_DataCleaning_Project/assets/105373494/c068fd43-07e2-4665-8664-a31e971c70bb)

Concluído a limpeza e transformação dos dados!














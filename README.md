# Clusterização de clientes
<p> Author : Ricardo Barbosa de Almeida Campos </p>

<p><img src = "images/segmentation.jpg"></p>

## Introdução
<p>Este é um projeto de ciência de dados que tem como objeto criar um modelo de aprendizagem de máquina, que seja capaz de criar clusters em um grupo de clientes de uma empresa de e-commerce, para traçar novas estratégias de vendas.Além de criar uma estrutura online para análise e captação constante dos dados.</p>

## Problema de negócio
<p>A empresa All in One Place é uma empresa Outlet Multimarcas, ou seja, ela comercializa produtos de segunda linha de várias marcas a um preço menor, através de um e-commerce.

Em pouco mais de 1 ano de operação, o time de marketing percebeu que alguns clientes da sua base, compram produtos mais caros, com alta frequência e acabam contribuindo com uma parcela significativa do faturamento da empresa.

Baseado nessa percepção, o time de marketing vai lançar um programa de fidelidade para os melhores clientes da base, chamado Insiders. Mas o time não tem um conhecimento avançado em análise de dados para eleger os participantes do programa.

Por esse motivo, o time de marketing requisitou ao time de dados uma seleção de clientes elegíveis ao programa, usando técnicas avançadas de manipulação de dados.</p>

## Dataset
<p>O dataset utilizado para treinar os modelos e realizar as clusterizações foi retirado da página web do link :<a href = "https://www.kaggle.com/datasets/carrie1/ecommerce-data"> Dataset de transações para lojas de E-commerce</a></p>
<p>Uma descrição de cada variável presente neste dataset pode ser encontrada na página.</p>

## Desenvolvimento
<p> O desenvolvimento de estudo seguiu diversos passos que compoem um estudo de clusterização na área de Ciência de Dados. Foram so seguintes passos:
<ul>
  <li> Coleta e Preparação</li>
  <li> Limpeza e Filtragem dos dados</li>
  <li> Feature Engineering </li>
  <li> EDA</li>
  <li> Preparação dos dados</li>
  <li> Seleção de atributos </li>
  <li> Ajuste fino dos hiper parâmetros</li>
  <li> Treinamento do modelo</li>
  <li> Análise dos Clusters </li>
  <li> EDA -  Pós Clusterização</li>
  <li> Preparação para produção</li>
</ul>
</p>

<p> Importante frisar que o prjeto foi divido em duas fases distintas, o desenvolvimento dos modelos de clusterização e análise dos dados. E a fase de produção, na qual o código foi embarcado em uym servidor Ubuntu para execução remota. Na fase de produção três produtos da AWS foram utilizados, o S3, que um repositório de arquivos, o RDS, que um banco de dados e o EC2, no qual é possível a criação de instâncias de servidor.</p>

### Coleta e Preparação

<p> Um problema bastante comum em preparação de dados para plataformas de E-commerce é a inconsistências nas respostas em campos abertos para que o usuário possa inserir dados, seja este usuário funcionário da empresa ou comprados. Duas colunas possuem inconsistência deste tipo, a do país e código do estoque. A do país só necessário somente remover duas linhas nas quais os países estão incorretos. Diferente da colunas de código do estoque, na qual os funcionários da empresa inseriram diversos códigos que não correspondem com produtos, como devoluções. O tratamento desta coluna será explicado mais a frente.</p>
<p> E para os dados de natureza númerica, inconsistências foram detectadas nas colunas de preços e quantidade. As quantidade negativas foram identificadas como devoluções e os produtos com preço 0, foram identificados como brindes.</p>


### Feature Engineering

<p> Nesta seção foram criadas algumas variáveis que normalmente são analisadas em problemas de E-commerce. As colunas novas são:
<ul>
  <li> Receita</li>
  <li> Recência </li>
  <li> Número de compras</li>
  <li> Quantidade de produtos comprados</li>
  <li> Tamanho médio da cesta</li>
  <li> Ticket médio </li>
  <li> Média de itens únicos </li>
  <li> Número de retornos </li>
  <li> Frequência de compras </li>
</ul>
</p>
<p>Nesta iteração do projeto, os dados faltantes gerados nesta etapa foram deletados porque a quantidade é bem pequena em relação ao total de clientes.</p>


### Seleção de atributos

<p> A seleção de atributos foram utilizados dois algoritmos para escolher quais variáveis seriam utilizadas para treinar os modelos de aprendizagem de máquina. O primeiro algoritmo foi o Boruta e o segundo foi o MRMR (Maximum Relevance — Minimum Redundancy). Para determinar o algoritmo que será utilizado, mais adiante no projeto serão comparados o erros dos modelos gerados.
</p>

### Modelos de Aprendizagem de Máquina

<p> Os modelos selecionados como candidatos foram:
<ul>
  <li> K-Means</li>
  <li> Hierarchical Clustering </li>
  <li> DBSCAN</li>
  <li> GMM</li>
</ul>

Não é pertinente deste projeto entrar em detalhes de como cada algoritmo funciona.</p>

<p>Os modelos serão treinados com os dados selecionados pelo Boruta e o MRMR, para verificar qual possui a melhor performance. O melhor modelo será selecionado de acordo com o RMSE e o tamanho do arquivo do modelo, que será gerado utilizando a biblioteca Pickle. </p>

#### Performance dos modelos utilizando o Boruta

| Nome do Modelo      |  MAE    | MAPE | RMSE    |
|:-------------------:|:-------:|:----:|:-------:|
| Regressão Linear    | 1966,81 | 0,31 | 2824,65 |
| Reg. Linear - Lasso | 1991,63 | 0,31 | 2871,34 |
| Random Forest       | 588,79  | 0,09 | 933,71  |
| XGBoost             | 822,30  | 0,12 | 1196,85 |

#### Performance dos modelos utilizando o MRMR

| Nome do Modelo      |  MAE    | MAPE | RMSE    |
|:-------------------:|:-------:|:----:|:-------:|
| Regressão Linear    | 1998,47 | 0,31 | 2876,59 |
| Reg. Linear - Lasso | 2007,33 | 0,31 | 2896,56 |
| Random Forest       | 1111,28 | 0,17 | 1598,83 |
| XGBoost             | 1183,50 | 0,18 | 1723,41 |



<p> De acordo com os valores das tabelas, os modelos recomendados seriam o Random Forest e o XGBoost com as variáveis selecionadas pelo Boruta.Mas o Random Forest quando salvo, gerou um modelo com o tamanho na casa das centenas de MB e o XGBoost gerou na casa das dezenas de MB. O tamanho do arquivo gerado é importante para a aplicação WEB que será gerada.</p>

### Ajuste fino dos hiper parâmetros

<p> O ajuste fino dos hiper parâmetros será realizado utilizando a otimização Bayesiana. Esta técnica de otimização vem do teorema de Bayes, na qual é possível determinar a probabilidade de um evento acontecer dada uma condição e baseando em uma informação prévia.
Para uma explicação mais detalhada ler este artigo - <a href = "https://distill.pub/2020/bayesian-optimization/"> Bayesian Optimization</a></p>
<p>Como o modelo de aprendizagem de máquina escolhido no parágrafo anterior foi XGBoost, o mesmo terá os parâmetros ajustados pela otimização Bayesiana. A tabela desta seção apresenta os resultados de error para o modelo.</p>

| Nome do Modelo      |  MAE    | MAPE | RMSE    |
|:-------------------:|:-------:|:----:|:-------:|
| XGBoost - Ajustado  | 578,40  | 0,08 | 858,78  |

## Insights de negócio

<p>Nesta seção serão apresentados alguns insights de negócio que foram descobertos durante a exploração dos dados.

<ul>

  <li> Lojas com maior sortimentos deveriam vender mais - FALSO </li>
  <li> Lojas com competidores mais próximos deveriam vender menos - FALSO </li>
  <li> Lojas com promoções por mais tempo deveriam vender mais - FALSO</li>
  <li> Lojas abertas durante o feriado de Natal deveriam vender mais - FALSO</li>
  <li> Lojas deveriam vender mais no final do ano - FALSO</li>
  <li> Lojas deveriam vender mais depois do dia 10 de cada mês - VERDADEIRO</li>
  <li> Lojas deveriam vender menos aos finais de semana - VERDADEIRO</li>
</ul>

</p>

## Resultados

### Performance do modelos
<p>Primeiro será debatido a performance do modelo para as predições.
Na primeira figura temos as varições de MAPE para cada loja dentro do dataset. Percebe-se que o valor máximo de MAPE sendo próximo dos 22,5% e o média está em torno de 7,5% para os modelos.  </p>


<p><img src = "images/mapes_store.png"></p>

<p> Na segunda imagem tem-se uma combinação de 4 imagens. A primeira é uma comparação dos valores de venda para o dataset de teste e o os valores gerados pelo modelo XGBoos. Na segunda figura tem-se a taxa de rro. Na terceira a distribuição dos erros e na quarta um gráfico de pontos para os valores absolutos de erro em relação as lojas.</p>

<p><img src = "images/model_performance.png"></p>

### Resultados de Negócio

  <p>Agora serão analisados os resultados de negócio com valores monetários. De acordo com a tabela abaixo, o modelo foi capaz de prever que o valor somado de vendas para todas as lojas com, levando em consideração a variação do MAPE.
  </p>


  | **Cenário**     | **Valor Predição (R$)** |
  |:---------------:|:-----------------------:|
  | Predição        | 936.071.580,89          |
  | Predição - MAPE | 935.225.007,35          |
  | Predição + MAPE | 936.918.154,43          |

  <p>Um dos pontos mais importantes do projeto seria a capacidade de prever o valor gerado por cada loja, para que os gerentes possam planejar as reformas da melhor maneira possível.
  Na tabela abaixo há uma demonstração dos valores para as lojas até 10, que estam presentes no dataset.
  </p>



| **Loja**        | **Valor Predição (R$)** |
|:---------------:|:-----------------------:|
| 1               | 183.831,97              |
| 3               | 264.979,76              |
| 7               | 283.135,59              |
| 8               | 230.571,40              |
| 9               | 299.926,65              |
| 10              | 227.134,88              |




## Próximos Passos

  <p> Uma aplicação web simples foi montada de forma que requisições provenientes de um script Python possam ser utilizadas como forma de realizar a predição. Mas para uma aplicação futura, seria bom desenvolver uma interface web  para tornar o processo de requisição mais amigável.
  </p>

  <p> Um outro ponto a ser enfrentado em um próximo desenvolvimento, seria a realização do processo de cross validation para todos os modelos.
  </p>

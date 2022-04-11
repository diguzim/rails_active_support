# frozen_string_literal: true

require "pry"
require "active_support/all"

### 5 Extensions to String ###

# 5.1 Output Safety

# 5.1.1 Motivation
# Essa sessão é relativa a uma questão de segurança de saída de strings, principalmente para usar no HTML

# 5.2 remove

p "Hello World".remove(/Hello /)

# 5.3 squish
# Remove espaços em branco excessivos, deixando somente um entre as palavras (e removendo os das pontas)
p "  Hello      World ".squish

# 5.4 truncate
# Corta a string em um tamanho específico, adicionando um indicador de que foi truncado
p "Art 5º Todos são iguais perante a lei, sem distinção de qualquer natureza, garantindo-se aos brasileiros e aos estrangeiros residentes no País a inviolabilidade do direito à vida, à liberdade, à igualdade, à segurança e à propriedade".truncate(42)
# Para usar outra coisa além de "...", basta passar uma opção "omission"
# Para truncar em uma parada natural (ex: espaços em branco), basta passar o parâmetro "separator"

# 5.5 truncate_bytes
# Trunca em função de bytes, não de caracteres

# 5.6 truncate_words
# Trunca em função de palavras, não de caracteres
p "Art 5º Todos são iguais perante a lei, sem distinção de qualquer natureza, garantindo-se aos brasileiros e aos estrangeiros residentes no País a inviolabilidade do direito à vida, à liberdade, à igualdade, à segurança e à propriedade".truncate_words(8)

# 5.7 inquiry
# Investigar, questionar, perguntar
# Converte uma string em um objeto do tipo "StringInquirer", que faz com que validação de igualdade sejam mais elegantes
p "production".inquiry.production? # => true
p "active".inquiry.inactive?       # => false
# Parece mágica né? Mas ele só tranforma a string em um símbolo com interrogação
p "active".inquiry.algoAleatorio? # => false

# 5.9 strip_heredoc
# Heredoc (here document) é uma seçaõ de texto dentro de um código
text = <<EXEMPLO
  É isso mesmo
  Esse é um texto muito louco, de varias linhas
    Bora ver o que acontece aqui que tem um tab a mais
EXEMPLO
p text
# Então a questão é usar esse duplo sinal de menor, seguido de algum identificador, que depois é utilizado para encerrar o heredoc

# Para melhorar a identação, podemos usar um hífen antes do identificador, assim podemos fechar ele na mesma identação
text =
  <<-EXEMPLO
    É isso mesmo
    Esse é um texto muito louco, de varias linhas
      Bora ver o que acontece aqui que tem um tab a mais
  EXEMPLO
p text

# Podemos desconsiderar a identação base(a linha menos identada) do texto no resultado final,
# utilizando o Squiggly Heredoc (~)
text =
  <<~EXEMPLO
    É isso mesmo
    Esse é um texto muito louco, de varias linhas
      Bora ver o que acontece aqui que tem um tab a mais
  EXEMPLO
p text

# O rails criou o método strip_heredoc para isso, antes de ser criado o internalziado Squiggly Heredoc
text =
  <<-EXEMPLO.strip_heredoc
    É isso mesmo
    Esse é um texto muito louco, de varias linhas
      Bora ver o que acontece aqui que tem um tab a mais
  EXEMPLO
p text

# 5.10 indent
# Faz meio que o inverso, ele justamente identa mais as linhas
text =
  <<-EXEMPLO.indent(2)
    É isso mesmo
    Esse é um texto muito louco, de varias linhas
      Bora ver o que acontece aqui que tem um tab a mais
  EXEMPLO
p text
# Mas serve pra qualquer string, não apenas para heredoc
text = "Olá!\nMeu nome é Rodrigo".indent(2)
p text
# Outras configurações:
# indent_string: string utilizada para identar (default: " ")
# indent_empty_lines: se deve identar linhas vazias (default falso)

# 5.11 Access
# Acesso a partes da string

# 5.11.1 at(position)
# Retorna a letra na posição x
p "hello".at(0)  # => "h"
p "hello".at(1)  # => "e"

# 5.11.2 from(position)
# Retorna a substring a partir da posição x
p "hello".from(0)  # => "hello"
p "hello".from(1)  # => "ello"
p "hello".from(-2)  # => "lo"
p "hello".from(10)  # => nil

# 5.11.3 to(position)
# Retorna a substring até a posição x
p "hello".to(0) # => "h"
p "hello".to(-2) # => "hell"
p "hello".to(10) # => "hello"

# 5.11.4 first(limit = 1)
# Retorna a substring contendo os primeiros x caracteres da string. Sem parâmetros x é 1
p "hello".first # => "h"
p "hello".first(1) # => "h"
p "hello".first(2) # => "h"
# p "hello".first(-1) # => sobe uma exceção ArgumentError

# 5.11.5 last(limit = 1)
# Retorna a substring contendo os últimos x caracteres da string. Sem parâmetros x é 1
p "hello".last # => "o"
p "hello".last(1) # => "o"
p "hello".last(2) # => "o"
# p "hello".last(-1) # => sobe uma exceção ArgumentError

# 5.12 Inflections
# É o processo de uma palavra aparecer em diferentes formas (ex: singular/plural), verbalmente (ex: infinitivo/passado)

# 5.12.1 pluralize
p "table".pluralize # => "tables"
p "ruby".pluralize # => "rubies"
p "equipment".pluralize # => "equipment"
# Esse último exemplo é um caso especial, pois o plural de "equipment" é "equipment"
# O Ruby tem uma biblioteca interna que registra algumas dessas inflexões irregulares
# Outras regras podem ser adicionadas em config/initializers/inflections.rb

# O pluralize recebe um parâmetro opcional, count
# Se o count for 1, o singular é retornado. Caso contrário, é o plural

p "mano".pluralize(1) # => "mano"
p "mano".pluralize(2) # => "manos"
p "mano".pluralize(0) # => "manos"
p "mano".pluralize(-54) # => "manos"

# 5.12.2 singularize
# É o inverso de pluralize
p "manos".singularize # => "mano"

# Sabem as associações do Active Record?
# Então, ele faz o uso do singularize para pegar o nome da classe associada

# 5.12.3 camelize
# Transforma as strings em camel case
p "hello".camelize # => "Hello"
p "hello_world".camelize # => "HelloWorld"
# Por via de regra pense que esse método transforma paths (caminhos) de arquivo em nome de módulos,
# com barras (slash, /)
p "securitizadora/do_some_magic_job".camelize # => "Securitizadora::DoSomeMagicJob"
# Um padrão comum é o camel case onde a primeira letra da primeira palavra mantém como minúscula
p "hello_world".camelize(:lower) # => "helloWorld"
# E tem um alias mais facil de memorizar
p "hello".camelcase # => "Hello"

# 5.12.4 underscore
# Faz o inverso do camelize
p "Securitizadora::DoSomeMagicJob".underscore
# O rails faz uso disso por baixo dos panos para pegar o nome de um controller em lower case
# provavelmente para associar nas rotas

# 5.12.5 titleize
# Deixa cada a primeira letra maiúscula de cada palavra de uma frase
p "projeto nacional de desenvolvimento".titleize # => "Projeto Nacional de Desenvolvimento"

# E existem diversos outros que fazem um monte de coisa similar
p "contact_data".dasherize # => "contact-data"
p "Backoffice::UsersController".demodulize # => "UsersController"
p "Backoffice::UsersController".deconstantize # => "Backoffice"
p "Getúlio Vargas".parameterize # => "getulio-vargas"
p "InvoiceLine".tableize # => "invoice_lines"
p "invoice_lines".classify # => "InvoiceLine" # => o inverso da de cima

# 5.12.12 constantize
# Resolve o valor de uma constante
module M
  X = 1
end
p "M::X".constantize # => 1
# Se não for uma constante válida, sobe uma exceção NameError

# 5.12.13 humanize
# Transforma uma string em algo mais agradável para exibir a um usuário
p "author_id".humanize # => "Author"

# No arquivo de inflections.rb, podemos definir alguns acrônimos
# Se tivessemos definido por exemplo, o PDT como um acrônimo
p "afiliados_pdt".humanize # => "Afiliados PDT"

# 5.12.14 foreign_key
# Transforma em um nome de coluna de chave externa
# Curiosamente, ele demodulariza, aplica o underscore e adiciona um _id no fim
p "CreditLineApplication".foreign_key # => "credit_line_application_id"
# Associações no Active Record usam para inferir o nome de chaves estrangeiras,
# por exemplo em relações de has_one e has_many

# 5.13 Conversions

# 5.13.1 to_date, to_time, to_datetime
# Alguns métodos de conveniência para transformar strings em objetos Date, Time ou DateTime

p "2010-07-27".to_date # => Tue, 27 Jul 2010
p "2010-07-27".to_date.class # => Date

p "2010-07-27 23:37:00".to_time # => 2010-07-27 23:37:00 +0200
p "2010-07-27 23:37:00".to_time.class # => Time

p "2010-07-27 23:37:00".to_datetime # => Tue, 27 Jul 2010 23:37:00 +0000
p "2010-07-27 23:37:00".to_datetime.class # => DateTime

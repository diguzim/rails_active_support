# O que é o Active Support
# É o componente do RoR responsável por prover a linguagem Ruby diversas extensões e utilidades,
# facilitando muito a # vida de geral

# frozen_string_literal: true

require "pry"
require "active_record"

### 1 How to Load Core Extensions ###

# 1.1 Stand-Alone Active Support
require "active_support" # This doesn't load almost anything

# 1.1.1 Cherry-picking a Definition
require "active_support/core_ext/hash/indifferent_access"
{ a: 1 }.with_indifferent_access["a"]

# 1.1.2 Loading Grouped Core Extensions
require "active_support/core_ext/hash" #  Load all extensions to Hash (including with_indifferent_access):
# 1.1.3 Loading All Core Extensions
require "active_support/core_ext"
# 1.1.4 Loading All Active Support
require "active_support/all" # Yet mostly everything is still only lazy-loaded through autoload

# Normalmente uma aplicação em RoR carrega todo o Active Support por padrão

### 2 Extensions to All Objects ###
# Aqui vamos falar de algumas extensões que podem ser aplicadas a todos os objetos

# 2.1 blank? and present?
# O que é blank?
## nil e false
## strings com somente espaços em branco
## arrays e hashes vazios
## demais objetos que respondem a blank?
vencedores = []
p "Não há vencedores" if vencedores.blank?

# O que é present?
## É o inverso do blank?
vencedores.push("Fulano")
p "Há vencedores" if vencedores.present?

# 2.2 presence
## Retorna o recebedor da mensagem se present?, e nil caso contrário
## Bom pra combinar com códigos defensivos
config = { host: "www.rodrigo.dinie.com" }
host = config[:host].presence || "localhost"
p host

# 2.3 duplicable? (I think this one should be skipped)
# most objects can be duplicated via dup or clone:
new_string = "foo".dup
p new_string
obj1 = { a: 1, b: 2 }
obj2 = obj1.dup
obj1[:a] = 5
p obj1, obj2
# and some things aren't duplicable:
# 1.method(:+).dup # => TypeError: can't dup method
# in order to know that beforehand, without raising an error:
1.method(:+).duplicable?

# 2.4 deep_dup
# Cria uma cópia profunda do objeto.
# Normalmente o dup faz uma cópia rasa, que caso haja outros sub-objetos,
# estes são copiados de maneira rasa, mante-se uma referência ao mesmo objeto.

obj1 = { a: { b: 2 } }
obj2 = obj1.dup
obj1[:a][:b] = 3
p obj1, obj2

obj1 = { a: { b: 2 } }
obj2 = obj1.deep_dup
obj1[:a][:b] = 3
p obj1, obj2

# 2.5 try
# Uma forma fácil de escrever código defensivo antes de enviar uma mensagem a um objeto que pode ser nulo

# without try
number = nil
result = nil
result = number.to_s unless number.nil?
p result

# with try
result = number.try(:to_s)
p result
# with number defined
number = 42
result = number.try(:to_s)
p result

# try pode ser usado sem argumentos mas somente com um bloco,
# que será executado somente se o objeto não for nulo
pessoa = nil
pessoa.try { |p| p "Olá, meu nome é #{p[:name]}" }
pessoa = { name: "Rodrigo" }
pessoa.try { |p| p "Olá, meu nome é #{p[:name]}" }

# try irá engolir erros de "no-method", e retornar nulo ao invés.
# Se você quiser tratar os erros de forma diferente, use o método try!
# idade = 32
# result = idade.try(:to_str)
# p result
# result = idade.try!(:to_str)
# p result

# 2.6 class_eval(*args, &block)
# Entendi porra nenhuma

# 2.7 acts_like?(duck)
# Uma forma de verificar se uma classe se comporta como outra classe,
# baseado em uma convenção de nomes de métodos.

# 2.8 to_param
# Todos os objetos em Rails respondem a esse método,
# que retorna uma string que representa o objeto,
# que pode ser usada como um parâmetro de URL / query string
result = 7.to_param
p result
result = { a: 1, b: 2 }.to_param
p result
# O rails utiliza por baixo dos panos quando vai pegar por exemplo o [:id] de uma model

# 2.9 to_query
# Constrói uma query string associada a uma dada chave com o valor de retorno de um to_param
uma_idade = 32
p uma_idade.to_query("idade")
# Aqui o uma_idade passou, por baixo dos panos, por um to_param, que retorna "32".
# E ele também escapa/adapta de caracteres se necessário
um_nome = "Rodrigo Marcondes"
p um_nome.to_query("pessoa[nome]")
# E quando passamos um hash, o rails utiliza o to_query para cada chave/valor
uma_pessoa = { nome: "Rodrigo Marcondes", idade: 32 }
p uma_pessoa.to_query("pessoa")

# 2.10 with_options
# É uma forma de "fatorar" opções em comum em uma série de chamadas de métodos, evitando duplicação

# Observe a duplicação
class Account < ActiveRecord::Base
  has_many :customers, dependent: :destroy
  has_many :products,  dependent: :destroy
  has_many :invoices,  dependent: :destroy
  has_many :expenses,  dependent: :destroy
end

# Resolvendo isso com with_options
class Account < ActiveRecord::Base
  with_options dependent: :destroy do |assoc|
    assoc.has_many :customers
    assoc.has_many :products
    assoc.has_many :invoices
    assoc.has_many :expenses
  end
end
# Também tem como aninhar construções com with_options

# 2.11 JSON support
# Oferece uma boa implementação do método to_json

# 2.12 Instance Variables
# O active support oferece diversos métodos para facilitar o acesso a variáveis de instância

# 2.12.1 instance_values
# Retorna um hash que mapeia variávies de instância para os seus valores
class C
  def initialize(x, y)
    @x, @y = x, y
  end
end

p C.new(0, 1).instance_values # => {"x" => 0, "y" => 1}

# 2.12.2 instance_variable_names
# Retorna um array com os nomes das variáveis de instância
class C
  def initialize(x, y)
    @x, @y = x, y
  end
end

p C.new(0, 1).instance_variable_names # => ["@x", "@y"]

# 2.13 Silencing Warnings and Exceptions
# Não entendi direito pra que serve

# 2.14 in?
# Testa se um objeto está contido em outro
# Irá gerar uma exceção se o argumento passado não responder a include?
p 1.in?([1, 2]) # => true
p "lo".in?("hello")   # => true
p 25.in?(30..50)      # => false
# p 1.in?(1)            # => ArgumentError

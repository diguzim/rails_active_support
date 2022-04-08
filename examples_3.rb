# frozen_string_literal: true

require "pry"
require "active_record"
require "active_support/all"

### 3 Extensions to Module ###

# 3.1 Attributes

# 3.1.1 alias_attribute
# É uma forma de chamar um atributo por outro nome (alias, pseudônimo)
# class User
#   def initialize(email)
#     @email = email
#   end

#   attr_reader :email
# end
# class AnotherUser < User
#   alias_attribute :login, :email
# end

# user = AnotherUser.new("rodrigo@dinie.com")
# p user.login, user.email

# 3.1.2 Internal Attributes
# Quando definimos uma subclasse é possível que acabemos sobrescrevendo nomes de atributos,
# principalmente aqueles que não fazem parte da interface pública
# Essa técnica ajuda a evitar esse tipo de problema
#TODO, não consegui usar corretamente

# 3.1.3 Module Attributes
# Mesma coisa que os cattr_* definidos em classes (veremos depois)

# 3.2 Parents

# 3.2.1 module_parent
# Retorna o pai do módulo
module X
  module Y
    module Z
    end
  end
end

p X::Y::Z.module_parent, X::Y::Z.module_parent.class

# 3.2.2 module_parent_name
# Retorna o nome do pai do módulo
p X::Y::Z.module_parent_name

# 3.2.3 module_parents
# Retorna toda a cadeia de pais do módulo
p X::Y::Z.module_parents

# 3.3 Anonymous
# Sobre módulos anônimos, não soa muito interessante

# 3.4 Method Delegation
# O macro delegate oferece uma forma fácil de encaminhar métodos de um objeto para outro
# É particularmente útil com associações do Active Record

# Obs: Instanciar essa classe só vai funcionar dentro do Rails
# class Profile < ActiveRecord::Base
#   attr_accessor :name, :age
# end

# class User < ActiveRecord::Base
#   has_one :profile

#   def name
#     profile.name
#   end
# end

# usando o delegate
# class User < ApplicationRecord
#   has_one :profile

#   delegate :name, to: :profile
# end

# obs: o método delegado deve ser público (no caso, em Profile)
# delegate :name, :age, to: :profile

# E o que acontece se o usuário não tiver um perfil, e tentar acessar um método do perfil?
# Por padrão da exceção, mas podemos retornar um nulo ao invés

# delegate :name, to: :profile, allow_nil: true
# user.name # => nil

# podemos adicionar um prefixo ao delegar
# delegate :name, to: :profile, prefix: true
# user.profile_name # => nil
# Podemos também customizar esse prefixo
# delegate :name, to: :profile, prefix: :register
# user.register_name # => nil

# Métodos delegados são públicos por padrão. Para torná-los privados basta:
# delegate :name, to: :profile, private: true
# user.name # => NoMethodError

# Tem como fazer muitas coisas legais: delegar para variáveis de instância, de classe, constantes, para a própria classe

# 3.4.2 delegate_missing_to
# Um método meio patético pra delegar todos métodos que não existem em um objeto para um outro objeto
# delegate_missing_to :profile

# 3.5 Redefining Methods
# O ruby possibilita definir métodos usando o método define_method,
# mas ele não sabe se o método já existe ou não. Se o método já existe, ele sobe um warning, e sobrescreve o método.
# O Rails oferece o método redefine_method, que não sobe warnings, remove o método antigo e criar o novo

class Salute
  def hello
    p "Hello"
  end
end

class Olar
  redefine_method(:hello) { p "Olar" }
end

Olar.new.hello

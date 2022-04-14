# frozen_string_literal: true

require "pry"
require "active_record"
require "active_support/all"

### 4 Extensions to Class ###

# 4.1 Class Attributes

# 4.1.1 class_attribute
# Define um atributo de classe que pode ser sobrescrito em subclasses
class A
  class_attribute :x
end

class B < A; end

class C < B; end

p A.x = :a
p B.x # => :a
p C.x # => :a

p B.x = :b
p A.x # => :a
p C.x # => :b

p C.x = :c
p A.x # => :a
p B.x # => :b

# E curiosamente eles também são acessíveis em objetos dessa classe
obj = A.new
p obj.x
# Podemos sobrescrever esses atributos em nível de instância:
obj.x = "hadouken"
p obj.x

# Mas se não quisermos sobrescrever esses atributos, podemos usar:
class Base
  class_attribute :x, instance_writer: false, default: "my"
end
obj = Base.new
# obj.x = "hadouken"
# existem todos os equivalentes para desabilitar: instance_reader, instance_writer, instance_accessor

# 4.1.2 cattr_reader, cattr_writer, and cattr_accessor
# Similares ao attr_*, porém para classes

class Classe
  cattr_accessor :quantidade
end

p Classe.quantidade
Classe.quantidade = 1
p Classe.quantidade

# Também rola passar um valor default
# cattr_accessor :quantidade, default: 0

# existem todos os equivalentes para desabilitar: instance_reader, instance_writer, instance_accessor

# 4.2 Subclasses and Descendants

# 4.2.1 subclasses
# Retorna as subclasses diretas da classe
p A.subclasses

# 4.2.2 descendants
# Retorna todos os descententes, mesmo os indiretos, da classe
p A.descendants

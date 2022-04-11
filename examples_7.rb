# frozen_string_literal: true

require "pry"
require "active_support/all"

### 7 Extensions to Numeric ###

# 7.2 Time

# Existem diversos métodos:
# seconds, minutes, hours, days, weeks

p 30.minutes, 30.minutes.class

# Podem ser adicionados ou subtraidos de objetos de tempo
time = Time.now + 30.minutes
p time

# alguns métodos que podem nos ajudar, from_now e ago
p 1.day.from_now
p 30.minutes.ago

# 7.3 Formatting
# Permite a formatação de números de diversas maneiras

# phone
# Não consegui fazer funcionar bem para o formato do BR
p 11_952_431_024.to_fs(:phone, area_code: true, country_code: 55)

# representação em formato financeiro
p 123_456_789.50.to_fs(:currency)
p 123_456_789.504.to_fs(:currency)
p 123_456_789.504.to_fs(:currency, precision: 5)

# representação em forma de porcentagem
p 100.to_fs(:percentage)
p 100.to_fs(:percentage, precision: 0)
p 1000.to_fs(:percentage, delimiter: ".", separator: ",")

# representação em formato com delimitadores
p 12_345_678.to_fs(:delimited)
p 12_345_678.99.to_fs(:delimited, delimiter: ".", separator: ",")

# representação de um número arredondado
p 111.2344.to_fs(:rounded)
p 111.2345.to_fs(:rounded)
p 111.2345.to_fs(:rounded, precision: 2)
p 13.to_fs(:rounded, precision: 5)
p 389.32314.to_fs(:rounded, precision: 0)
p 111.2345.to_fs(:rounded, significant: true)

# representação de um tamanho de arquivo em formato legível por humanos de bytes
p 123.to_fs(:human_size)                  # => 123 Bytes
p 1234.to_fs(:human_size)                 # => 1.21 KB
p 12_345.to_fs(:human_size) # => 12.1 KB
p 1_234_567.to_fs(:human_size) # => 1.18 MB
p 1_234_567_890.to_fs(:human_size) # => 1.15 GB
p 1_234_567_890_123.to_fs(:human_size) # => 1.12 TB
p 1_234_567_890_123_456.to_fs(:human_size) # => 1.1 PB
p 1_234_567_890_123_456_789.to_fs(:human_size) # => 1.07 EB

# representação de um número em palavras humanas legíveis
p 123.to_fs(:human)               # => "123"
p 1234.to_fs(:human)              # => "1.23 Thousand"
p 12_345.to_fs(:human) # => "12.3 Thousand"
p 1_234_567.to_fs(:human) # => "1.23 Million"
p 1_234_567_890.to_fs(:human) # => "1.23 Billion"
p 1_234_567_890_123.to_fs(:human) # => "1.23 Trillion"
p 1_234_567_890_123_456.to_fs(:human)  # => "1.23 Quadrillion"

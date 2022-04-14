# frozen_string_literal: true

require "pry"
require "active_support/all"

### 8 Extensions to Integer ###

# 8.4 Time
# Para Inteiros, podemos usar os métodos months e years
r = 1.months + 2.years
p r, r.class
# E porque estamos falando deles só agora e não mencionamos antes?
# Porque por algum motivo os anteriores funcionavam para quaisquer valores numéricos (ex floats),
# Enquanto months e years funcionam somente para Inteiros
# p 1.5.months # => da exceção
p r + 3.4.weeks

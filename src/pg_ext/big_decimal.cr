require "big"

module PG
  struct Numeric
    # Returns a BigDecimal representation of the numeric. This retains all precision.
    def to_big_d
      return BigDecimal.new("0") if nan? || ndigits == 0

      string = String.build do |str|
        str << digits.first || 0
        next unless digits[1]
        str << '.'
        str << digits[1]
      end

      quot = BigDecimal.new(string)
      neg? ? -quot : quot
    end
  end

  class ResultSet
    def read(t : BigDecimal.class)
      read(PG::Numeric).to_big_d
    end

    def read(t : BigDecimal?.class)
      read(PG::Numeric?).try &.to_big_d
    end
  end
end

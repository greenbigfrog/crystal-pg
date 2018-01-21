require "big"

module PG
  struct Numeric
    # Returns a BigDecimal representation of the numeric. This retains all precision.
    def to_big_d
      return BigDecimal.new("0") if nan? || ndigits == 0

      ten_k = BigInt.new(10_000)
      num = digits.reduce(BigInt.new(0)) { |a, i| a*ten_k + BigInt.new(i) }
      # den = ten_k**(ndigits - 1 - weight)
      # quot = BigRational.new(num, den)
      quot = BigDecimal.new(num)
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

defmodule Papyrus.Algorithms do

  @doc """
  Calculate the greatest common divisor of two numbers using the Euclidean algorithm

  ## Examples

      iex> Papyrus.Algorithms.extended_euclidean_algorithm(1769, 551)
      {29, 5, -16}
  """
  def extended_euclidean_algorithm(m, n) do
    if (n < 0 || m < 0) do
      raise ArgumentError, "Both numbers must be positive"
    end
    a = 0
    b = 1
    a! = 1
    b! = 0
    if (n > m) do
     _extended_euclidean_algorithm(a, b, a!, b!,n, m)
    else
    _extended_euclidean_algorithm(a, b, a!, b!,m, n)
    end
  end

  defp _extended_euclidean_algorithm(a, b, a!, b!, c, d) do
    q = div(c, d)
    r = rem(c, d)
    if r == 0 do
      {d, a, b}
    else
      _extended_euclidean_algorithm(a! - q * a, b! - q * b, a, b, d, r)
    end
  end

end

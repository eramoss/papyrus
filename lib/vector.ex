defmodule Papyrus.Vector do
  @doc """
  Adds two vectors

  ## Examples

      iex> Papyrus.Vector.add([1, 2], [3, 4])
      [4, 6]
  """
  def add(vec_a, vec_b) do
    Enum.zip(vec_a, vec_b) |> Enum.map(fn {a, b} -> a + b end)
  end

  @doc """
  Multiply a vector by a scalar

  ## Examples

      iex> Papyrus.Vector.multiply([1, 2], 2)
      [2, 4]
  """
  def multiply(vec, a) do
    Enum.map(vec, fn x -> x * a end)
  end

  @doc """
  Multiply two vectors element-wise
  (dot product)

  ## Examples

      iex> Papyrus.Vector.dot_product([1, 2], [3, 4])
      11
  """
  def dot_product(vec_a, vec_b) do
    if length(vec_a) != length(vec_b) do
      raise ArgumentError, "Row and column lengths must be the same"
    else
    Enum.zip(vec_a, vec_b) |> Enum.reduce(0, fn {a, b}, acc -> a * b + acc end)
    end
  end

  @doc """
  Calculate the cross product of two vectors

  ## Examples

      iex> Papyrus.Vector.cross_product([1, 2, 3], [4, 5, 6])
      [-3, 6, -3]
  """
  def cross_product(vec_a, vec_b) do
    if (length(vec_b) != 3 && length(vec_a) != 3) do
      raise ArgumentError, "Cross product is only defined between two 3 dimensional vectors"
    end
    [
      Enum.at(vec_a, 1) * Enum.at(vec_b, 2) - Enum.at(vec_a, 2) * Enum.at(vec_b, 1),
      Enum.at(vec_a, 2) * Enum.at(vec_b, 0) - Enum.at(vec_a, 0) * Enum.at(vec_b, 2),
      Enum.at(vec_a, 0) * Enum.at(vec_b, 1) - Enum.at(vec_a, 1) * Enum.at(vec_b, 0)
    ]
  end

  @doc """
  get magnitude of a vector

  ## Examples

      iex> Papyrus.Vector.magnitude([1, 2])
      2.23606797749979
  """
  def magnitude(vec) do
    :math.sqrt(Enum.reduce(vec, 0, fn x, acc -> x * x + acc end))
  end

  @doc """
  get euclidean distance between two vectors

  ## Examples

      iex> Papyrus.Vector.euclidean_distance([1, 2], [3, 4])
      2.8284271247461903
  """
  def euclidean_distance(vec_a, vec_b) do
    magnitude(add(vec_a, multiply(vec_b, -1)))
  end

  @doc """
  get cosine similarity between two vectors

  ## Examples

      iex> Papyrus.Vector.cosine_similarity([1, 2], [3, 4])
      0.9838699100999074
  """
  def cosine_similarity(vec_a, vec_b) do
    product = dot_product(vec_a, vec_b)
    product / (magnitude(vec_a) * magnitude(vec_b))
  end

  @doc """
  get angle between two vectors

  ## Examples

      iex> Papyrus.Vector.angle([1, 2], [3, 4])
      0.17985349979247847
  """
  def angle(vec_a, vec_b) do
    :math.acos(cosine_similarity(vec_a, vec_b))
  end


end

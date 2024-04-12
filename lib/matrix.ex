defmodule Matrix do
  @moduledoc """
  A module for performing operations on matrices.
  """

  @doc """
  Adds two matrices together.

  ## Examples

      iex> Matrix.add([[1, 2], [3, 4]], [[5, 6], [7, 8]])
      [[6, 8], [10, 12]]
  """
  def add(matrix_a, matrix_b) do
    if length(matrix_a) != length(matrix_b) do
      raise ArgumentError, "Matrices must have the same dimensions"
    else
      Enum.zip(matrix_a, matrix_b) |> Enum.map(fn {a, b} -> add_row(a, b) end)
    end
  end

  @doc """
  Adds two rows of a matrix together.

  ## Examples

      iex> Matrix.add_row([1, 2], [3, 4])
      [4, 6]
  """
  def add_row(row_a, row_b) do
    Enum.zip(row_a, row_b) |> Enum.map(fn {a, b} -> a + b end)
  end

  @doc """
  Multiplies a matrix by a scalar.

  ## Examples

      iex> Matrix.multiply_linear([[1, 2], [3, 4]], 2)
      [[2, 4], [6, 8]]
  """
  def multiply_linear(matrix, a) do
    Enum.map(matrix, fn row -> multiply_row(row, a) end)
  end

  @doc """
  Multiplies two matrices together.

  ## Examples

      iex> Matrix.multiply([[1, 2], [3, 4]], [[5, 6], [7, 8]])
      [[19, 22], [43, 50]]
  """
  def multiply(matrix_a, matrix_b) do
    Enum.map(matrix_a, fn row_a ->
      Enum.map(transpose(matrix_b), fn col_b ->
        multiply_row_col(row_a, col_b)
      end)
    end)
  end

  @doc """
  Multiplies a row and a column of a matrix.

  ## Examples

      iex> Matrix.multiply_row_col([1, 2], [3, 4])
      11
  """
  def multiply_row_col(row, col) do
    if length(row) != length(col) do
      raise ArgumentError, "Row and column lengths must be the same"
    else
      Enum.zip(row, col) |> Enum.reduce(0, fn {a, b}, acc -> a * b + acc end)
    end
  end

  @doc """
  Multiplies a row of a matrix by a scalar.

  ## Examples

      iex> Matrix.multiply_row([1, 2], 2)
      [2, 4]
  """
  def multiply_row(row, a) do
    Enum.map(row, fn x -> x * a end)
  end

  @doc """
  Transposes a matrix.

  ## Examples

      iex> Matrix.transpose([[1, 2], [3, 4]])
      [[1, 3], [2, 4]]
  """
  def transpose(matrix) do
    Enum.map(0..(length(hd(matrix)) - 1), fn i -> Enum.map(matrix, fn row -> Enum.at(row, i) end) end)
  end

  @doc """
  swap rows of a matrix

  ## Examples

      iex> Matrix.swap_rows([[1, 2], [3, 4]], 0, 1)
      [[3, 4], [1, 2]]
  """
  def swap_rows(matrix, i, j) do
    Enum.with_index(matrix) |> Enum.map(fn {row, idx} ->
      if idx == i do
        Enum.at(matrix, j)
      else if idx == j do
        Enum.at(matrix, i)
      else
        row
        end
      end
    end)
  end


  @doc """
  Convert a matrix to echelon form

  ## Examples

      iex> Matrix.echelon_form([[1,2],[3,4]])
      [[1, 2], [0.0, -2.0]]
  """
  def echelon_form(matrix) do
    echelon_form(matrix, false) # tracker swaps to false
  end

  def echelon_form(matrix, false) do
    Enum.reduce(0..(length(matrix) - 2), matrix, fn i, acc ->
      Enum.reduce(i..(length(matrix) - 2), acc, fn j, acc2 ->
          pivot = Enum.at(Enum.at(acc2, i), i)
          if pivot == 0 do
            swap_rows(acc2, i, i + 1)
          else
            multiplier = Papyrus.Utils.inverse_multiplier(pivot, Enum.at(Enum.at(acc2, j + 1), i))
            replace_row(acc2, j + 1, add_row(Enum.at(acc2, j + 1), multiply_row(Enum.at(acc2, i), multiplier)))
          end
        end)
      end)
  end

  def echelon_form(matrix, true) do
    Enum.reduce(0..(length(matrix) - 2), {matrix, 0}, fn i, {acc, swaps} ->
      Enum.reduce(i..(length(matrix) - 2), {acc, swaps}, fn j, {acc2, swaps2} ->
        pivot = Enum.at(Enum.at(acc2, i), i)
        if pivot == 0 do
          {swap_rows(acc2, i, i + 1), swaps2 + 1}
        else
          multiplier = Papyrus.Utils.inverse_multiplier(pivot, Enum.at(Enum.at(acc2, j + 1), i))
          {replace_row(acc2, j + 1, add_row(Enum.at(acc2, j + 1), multiply_row(Enum.at(acc2, i), multiplier))), swaps2}
        end
      end)
    end)
  end


  @doc """
  Calculate the determinant of a matrix using echelon form

  ## Examples

      iex> Matrix.det_by_echelon([[0,4,5], [1,2,3], [6,7,8]])
      15.0
  """
  def det_by_echelon(matrix) do
    {echelon, swaps} = echelon_form(matrix, true)
    det = Enum.reduce(0..(length(echelon) - 1), 1, fn i, acc -> acc * Enum.at(Enum.at(echelon, i), i) end)
    det * :math.pow(-1, swaps)
  end


  @doc """
  Replace a row in a matrix

  ## Examples

      iex> Matrix.replace_row([[1,2],[3,4]], 0, [5,6])
      [[5, 6], [3, 4]]

  """
  def replace_row(matrix, i, row) do
    Enum.with_index(matrix) |> Enum.map(fn {r, idx} -> if idx == i do row else r end end)
  end

end

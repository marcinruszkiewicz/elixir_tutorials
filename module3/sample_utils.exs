defmodule Sample.Utils do
  def square(val) do
    val * val
  end

  def sum(a, b) do
    a + b
  end

  def custom_func(a, f) do
    f.(a)
  end
end

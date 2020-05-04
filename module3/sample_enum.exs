defmodule Sample.Enum do
  def first(list, val \\ nil)
  def first([head | _], _), do: head
  def first([], val), do: val

  def add(list, val \\ 0) do
    trace(val)
    [val | list]
  end

  defp trace(string) do
    IO.puts "The value passed was #{string}."
  end

  def map([], _), do: []
  def map([hd | tl], f) do
    [f.(hd) | map(tl, f)]
  end
end
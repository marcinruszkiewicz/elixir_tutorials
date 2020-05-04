defmodule Sample.Beer do
  import IO, only: [puts: 1]

  def verse(number) do
    puts "#{number} bottles of beer on the wall, #{number} bottles of beer."
    puts second_line(number)
    puts ""
    unless number == 0, do: verse(number - 1)
  end

  def second_line(number) do
    case number do
      0 -> "Take it down, pass it around, no more bottles of beer on the wall."
      1 -> "Take one down, pass it around, one more bottle of beer on the wall"
      _ -> "Take one down, pass it around, #{number - 1} bottles of beer on the wall."
    end
  end
end
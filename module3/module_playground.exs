defmodule ModulePlayground do
  import IO, only: [puts: 1]
  import Kernel, except: [inspect: 1]

  alias ModulePlayground.Misc.Util.Math, as: MyMath

  require Integer

  def say_here do
    inspect "I'm here"
  end

  def inspect(param1) do
    puts "Starting output"
    puts param1
    puts "EndingOutput"
  end

  def print_sum do
    MyMath.add(5, 10)
  end

  def print_is_even(num) do
    puts "Is #{num} even? #{Integer.is_even(num)}"
  end
end

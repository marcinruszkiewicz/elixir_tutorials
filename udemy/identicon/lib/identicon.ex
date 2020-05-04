defmodule Identicon do
  @moduledoc """
    Generates and identity icon for the given string and saves it as an image.
  """

  @doc """
    Generates an identity icon image.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Returns an encoded hash of the `input` as a `Identicon.Image` struct.

  ## Examples

    iex> Identicon.hash_input('banana')
    %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
    Returns the first 3 values of the encoded hex hash as an RGB color.

  ## Examples

    iex> image = Identicon.hash_input('banana')
    iex> Identicon.pick_color(image)
    %Identicon.Image{color: {114, 179, 2}, hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Builds an indexed 5x5 grid of pixel values to use as an image data

  ## Examples

    iex> image = Identicon.hash_input('banana')
    iex> Identicon.build_grid(image)
    %Identicon.Image{
      grid: [
        {114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4},
        {191, 5}, {41, 6}, {122, 7}, {41, 8}, {191, 9},
        {34, 10}, {138, 11}, {117, 12}, {138, 13}, {34, 14},
        {115, 15}, {1, 16}, {35, 17}, {1, 18}, {115, 19},
        {239, 20}, {239, 21}, {124, 22}, {239, 23}, {239, 24}
      ],
      hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
    }
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Mirrors a list.

  ## Examples

    iex> Identicon.mirror_row [1, 2, 3]
    [1, 2, 3, 2, 1]
  """
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
    Filters out grid squares that have odd values.

  ## Examples

    iex> image = Identicon.hash_input('banana')
    iex> grid = Identicon.build_grid(image)
    iex> Identicon.filter_odd_squares(grid)
    %Identicon.Image{
      grid: [
        {114, 0}, {2, 2}, {114, 4}, {122, 7},
        {34, 10}, {138, 11}, {138, 13}, {34, 14},
        {124, 22}
      ],
      hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
    }
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Makes a pixel map with {x,y} positions for rectangles

  ## Examples

    iex> image = Identicon.hash_input('banana')
    iex> grid = Identicon.build_grid(image)
    iex> filtered = Identicon.filter_odd_squares(grid)
    iex> Identicon.build_pixel_map(filtered)
    %Identicon.Image{
      grid: [
        {114, 0}, {2, 2}, {114, 4},
        {122, 7}, {34, 10}, {138, 11},
        {138, 13}, {34, 14}, {124, 22}
      ],
      hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65],
      pixel_map: [
        {{0, 0}, {50, 50}}, {{100, 0}, {150, 50}},
        {{200, 0}, {250, 50}}, {{100, 50}, {150, 100}},
        {{0, 100}, {50, 150}}, {{50, 100}, {100, 150}},
        {{150, 100}, {200, 150}}, {{200, 100}, {250, 150}},
        {{100, 200}, {150, 250}}
      ]
    }
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      x1 = rem(index, 5) * 50
      y1 = div(index, 5) * 50

      top_left = {x1, y1}
      bottom_right = {x1 + 50, y1 + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    fill = :egd.color(color)
    image = :egd.create(250, 250)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end

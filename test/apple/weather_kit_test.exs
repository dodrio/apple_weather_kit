defmodule Apple.WeatherKitTest do
  use ExUnit.Case
  doctest Apple.WeatherKit

  test "greets the world" do
    assert Apple.WeatherKit.hello() == :world
  end
end

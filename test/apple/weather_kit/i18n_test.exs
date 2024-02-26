defmodule Apple.WeatherKit.I18nTest do
  use ExUnit.Case
  doctest Apple.WeatherKit.I18n

  @possible_condition_codes [
    "BlowingDust",
    "Clear",
    "Cloudy",
    "Foggy",
    "Haze",
    "MostlyClear",
    "MostlyCloudy",
    "PartlyCloudy",
    "Smoky",
    "Breezy",
    "Windy",
    "Drizzle",
    "HeavyRain",
    "IsolatedThunderstorms",
    "Rain",
    "SunShowers",
    "ScatteredThunderstorms",
    "StrongStorms",
    "Thunderstorms",
    "Frigid",
    "Hail",
    "Hot",
    "Flurries",
    "Sleet",
    "Snow",
    "SunFlurries",
    "WintryMix",
    "Blizzard",
    "BlowingSnow",
    "FreezingDrizzle",
    "FreezingRain",
    "HeavySnow",
    "Hurricane",
    "TropicalStorm"
  ]

  describe "condition_name/2" do
    test "supports 34 condition codes" do
      assert Enum.count(@possible_condition_codes) == 34
    end

    test "supports locale - en" do
      for condition_code <- @possible_condition_codes do
        assert {:ok, _} = Apple.WeatherKit.I18n.condition_name(condition_code, "en")
      end
    end

    test "supports locale - zh-Hans" do
      for condition_code <- @possible_condition_codes do
        assert {:ok, _} = Apple.WeatherKit.I18n.condition_name(condition_code, "zh-Hans")
      end
    end

    test "supports locale - zh-Hant" do
      for condition_code <- @possible_condition_codes do
        assert {:ok, _} = Apple.WeatherKit.I18n.condition_name(condition_code, "zh-Hant")
      end
    end
  end
end

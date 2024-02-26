defmodule Apple.WeatherKit.Condition do
  @moduledoc """
  Provides static data about conditions.
  """

  @all_conditions [
    %{
      code: "BlowingDust",
      type: "visibility",
      description: "Blowing dust or sandstorm"
    },
    %{
      code: "Clear",
      type: "visibility",
      description: ""
    },
    %{
      code: "Cloudy",
      type: "visibility",
      description: "Cloudy, overcast conditions"
    },
    %{
      code: "Foggy",
      type: "visibility",
      description: "Fog"
    },
    %{
      code: "Haze",
      type: "visibility",
      description: "Haze"
    },
    %{
      code: "MostlyClear",
      type: "visibility",
      description: "Mostly clear"
    },
    %{
      code: "MostlyCloudy",
      type: "visibility",
      description: "Mostly cloudy"
    },
    %{
      code: "PartlyCloudy",
      type: "visibility",
      description: "Partly cloudy"
    },
    %{
      code: "Smoky",
      type: "visibility",
      description: "Smoky"
    },
    %{
      code: "Breezy",
      type: "wind",
      description: "Breezy, light wind"
    },
    %{
      code: "Windy",
      type: "wind",
      description: "Windy"
    },
    %{
      code: "Drizzle",
      type: "precipitation",
      description: "Drizzle or light rain"
    },
    %{
      code: "HeavyRain",
      type: "precipitation",
      description: "Heavy rain"
    },
    %{
      code: "IsolatedThunderstorms",
      type: "precipitation",
      description: "Thunderstorms covering less than 1/8 of the forecast area"
    },
    %{
      code: "Rain",
      type: "precipitation",
      description: "Rain"
    },
    %{
      code: "SunShowers",
      type: "precipitation",
      description: "Rain with visible sun"
    },
    %{
      code: "ScatteredThunderstorms",
      type: "precipitation",
      description: "Numerous thunderstorms spread across up to 50% of the forecast area"
    },
    %{
      code: "StrongStorms",
      type: "precipitation",
      description: "Notably strong thunderstorms"
    },
    %{
      code: "Thunderstorms",
      type: "precipitation",
      description: "Thunderstorms"
    },
    %{
      code: "Frigid",
      type: "hazardous",
      description: "Frigid conditions, low temperatures, or ice crystals"
    },
    %{
      code: "Hail",
      type: "hazardous",
      description: "Hail"
    },
    %{
      code: "Hot",
      type: "hazardous",
      description: "High temperatures"
    },
    %{
      code: "Flurries",
      type: "winter-precipitation",
      description: "Flurries or light snow"
    },
    %{
      code: "Sleet",
      type: "winter-precipitation",
      description: "Sleet"
    },
    %{
      code: "Snow",
      type: "winter-precipitation",
      description: "Snow"
    },
    %{
      code: "SunFlurries",
      type: "winter-precipitation",
      description: "Snow flurries with visible sun"
    },
    %{
      code: "WintryMix",
      type: "winter-precipitation",
      description: "Wintry mix"
    },
    %{
      code: "Blizzard",
      type: "hazardous-winter",
      description: "Blizzard"
    },
    %{
      code: "BlowingSnow",
      type: "hazardous-winter",
      description: "Blowing or drifting snow"
    },
    %{
      code: "FreezingDrizzle",
      type: "hazardous-winter",
      description: "Freezing drizzle or light rain"
    },
    %{
      code: "FreezingRain",
      type: "hazardous-winter",
      description: "Freezing rain"
    },
    %{
      code: "HeavySnow",
      type: "hazardous-winter",
      description: "Heavy snow"
    },
    %{
      code: "Hurricane",
      type: "tropical-hazard",
      description: "Hurricane"
    },
    %{
      code: "TropicalStorm",
      type: "tropical-hazard",
      description: "Tropical storm"
    }
  ]

  @doc """
  Lists all possible conditions.

  Every condition contains three attributes:

    * `code` (string)
    * `type` (string), possible values are:
      * `"visibility"`
      * `"wind"`
      * `"precipitation"`
      * `"hazardous"`
      * `"winter-precipitation"`
      * `"hazardous-winter"`
      * `"tropical-hazard"`
    * `description` (string)

  > All the possible conditions are extracted from
  [WeatherKit / WeatherCondition](https://developer.apple.com/documentation/weatherkit/weathercondition).

  """
  @spec list_conditions() :: [map(), ...]
  def list_conditions, do: @all_conditions
end

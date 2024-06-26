defmodule Apple.WeatherKit do
  @moduledoc """
  A client for Apple's WeatherKit REST API.

  ## Quick Start

  Before using `#{inspect(__MODULE__)}`, you need a basic understanding of the
  WeatherKit REST API. Checkout [WeatherKit REST API](https://developer.apple.com/documentation/weatherkitrestapi).

  Then, you can start using this package:

      # 1. build the config
      config =
        Apple.WeatherKit.Config.new!(
          team_id: "XXXXXXXXXX",
          service_id: "com.example.weatherkit-client",
          key_id: "YYYYYYYYYY",
          private_key: "-----BEGIN PRIVATE KEY-----\\n...\\n-----END PRIVATE KEY-----"
        )

      # 2. make the request
      Apple.WeatherKit.current_weather(config, 27.637, 120.699)

      # It returns:
      #
      # {:ok,
      #  %{
      #    "current_weather" => %{
      #      "as_of" => "2024-02-25T09:24:38Z",
      #      "cloud_cover" => 0.39,
      #      "cloud_cover_high_alt_pct" => 0.0,
      #      "cloud_cover_low_alt_pct" => 0.6,
      #      # ...
      #    }
      #  }
      # }

  > You may notice that `#{inspect(__MODULE__)}` convert the keys in response to snake-cased keys,
  > which is used in Elixir community conventionally.

  ## All possible values of `conditionCode`?

  WeatherKit REST API doesn't provide a list of all possible `conditionCode`,
  but WeatherKit Swift API does.

  Please check out `Apple.WeatherKit.Condition` for more information.

  ## References

    * [WeatherKit REST API](https://developer.apple.com/documentation/weatherkitrestapi)
    * [WeatherKit](https://developer.apple.com/documentation/weatherkit)

  """

  alias __MODULE__.Request
  alias __MODULE__.Config

  @typedoc """
  The name of language, like `"en"`, `"zh-CN"`, `"zh-HK"`.
  """
  @type language :: String.t()

  @typedoc """
  The latitude of the requested location.

  The value should be between `-90` and `90`.
  """
  @type latitude :: number()

  defguard is_latitude(value) when is_number(value) and value >= -90 and value <= 90

  @typedoc """
  The longitude of the requested location.

  The value should be between `-180` and `180`.
  """
  @type longitude :: number()

  defguard is_longitude(value) when is_number(value) and value >= -180 and value <= 180

  @typedoc """
  The ISO Alpha-2 country code for the requested location, like `"US"`.
  """
  @type country_code :: String.t()

  @typedoc """
  Available data sets.

  It can be:

    * `"currentWeather"`
    * `"forecastDaily"`
    * `"forecastHourly"`
    * `"forecastNextHour"`
    * `"weatherAlerts"`

  """
  @type data_set :: String.t()

  @typedoc """
  The data sets to include in the response for batch request.
  """
  @type data_sets :: [data_set(), ...]

  @type result :: {:ok, map()} | {:error, Exception.t()}

  @doc """
  Obtains the list of data sets available for the requested location.

  When `country_code` argument is provided, the data sets of air quality
  and weather alerts will be taken into consideration, or they are will
  be always ignored from the list.
  """
  @spec available_data_sets(Config.t(), latitude(), longitude()) :: result()
  def available_data_sets(%Config{} = config, latitude, longitude) do
    path = build_availability_path(latitude, longitude)
    params = []
    Request.get(config, path, params)
  end

  @spec available_data_sets(Config.t(), latitude(), longitude(), country_code()) :: result()
  def available_data_sets(%Config{} = config, latitude, longitude, country_code) do
    path = build_availability_path(latitude, longitude)
    params = [country: country_code]
    Request.get(config, path, params)
  end

  defp build_availability_path(latitude, longitude) do
    "/api/v1/availability/#{latitude}/#{longitude}"
  end

  @doc_language "`language` - the name of language. Default to `\"en\"`."
  @doc_timezone "`timezone` - the name of timezone which is use for rolling up weather forecasts into daily forecasts." <>
                  "Default to `\"Etc/UTC\"`."
  @doc_current_as_of "`current_as_of` - the UTC datetime string to obtain current conditions. " <>
                       "Default to UTC datatime string of now, like `\"2024-02-15T19:23:45Z\"`."
  @doc_daily_start "`daily_start` - The UTC datetime string whose day will be used to start the daily forecast. " <>
                     "Default to UTC datetime string of now, like `\"2024-02-15T19:23:45Z\"`."
  @doc_daily_end "`daily_end` - The UTC datetime string whose day will be used to end the daily forecast. " <>
                   "Default to UTC datetime string of now plus 10 days, like `\"2024-02-25T19:23:45Z\"`."
  @doc_hourly_start "`hourly_start` - The UTC datetime string whose hour will be used to start the hourly forcast." <>
                      "Default to UTC datetime string of now, like `\"2024-02-15T19:23:45Z\"`."
  @doc_hourly_end "`hourly_end` - The UTC datetime string whose hour will be used to end the hourly forcast." <>
                    "Default to UTC datetime string of 24 hours or the length of the daily forecast, whichever is longer, like `\"2024-02-16T19:23:45Z\"`."
  @doc_country_code "`country_code` - The ISO Alpha-2 country code for the requested location, like `\"US\"`."

  @doc """
  Obtains the current weather for the requested location.

  ## Options

    * #{@doc_language}
    * #{@doc_current_as_of}

  """
  @spec current_weather(Config.t(), latitude(), longitude(), keyword()) :: result()
  def current_weather(%Config{} = config, latitude, longitude, opts \\ [])
      when is_latitude(latitude) and is_longitude(longitude) do
    path = build_weather_path(latitude, longitude, opts)
    params = build_weather_params([data_sets: "currentWeather"], opts)
    Request.get(config, path, params)
  end

  @doc """
  Obtains the daily forecast for the requested location.

  ## Options

    * #{@doc_language}
    * #{@doc_timezone}
    * #{@doc_daily_start}
    * #{@doc_daily_end}

  """
  @spec forecast_daily(Config.t(), latitude(), longitude(), keyword()) :: result()
  def forecast_daily(%Config{} = config, latitude, longitude, opts \\ [])
      when is_latitude(latitude) and is_longitude(longitude) do
    path = build_weather_path(latitude, longitude, opts)
    params = build_weather_params([data_sets: "forecastDaily"], opts)
    Request.get(config, path, params)
  end

  @doc """
  Obtains the hourly forecast for the requested location.

  ## Options

    * #{@doc_language}
    * #{@doc_hourly_start}
    * #{@doc_hourly_end}

  """
  @spec forecast_hourly(Config.t(), latitude(), longitude(), keyword()) :: result()
  def forecast_hourly(%Config{} = config, latitude, longitude, opts \\ [])
      when is_latitude(latitude) and is_longitude(longitude) do
    path = build_weather_path(latitude, longitude, opts)
    params = build_weather_params([data_sets: "forecastHourly"], opts)
    Request.get(config, path, params)
  end

  @doc """
  Obtains the next hour forecast for the requested location.

  ## Options

    * #{@doc_language}
    * #{@doc_current_as_of}

  """
  @spec forecast_next_hour(Config.t(), latitude(), longitude(), keyword()) :: result()
  def forecast_next_hour(%Config{} = config, latitude, longitude, opts \\ [])
      when is_latitude(latitude) and is_longitude(longitude) do
    path = build_weather_path(latitude, longitude, opts)
    params = build_weather_params([data_sets: "forecastNextHour"], opts)
    Request.get(config, path, params)
  end

  @doc """
  Obtains weather alerts for the requested location.

  ## Options

    * #{@doc_language}
    * #{@doc_timezone}

  """
  @spec weather_alerts(Config.t(), latitude(), longitude(), country_code(), keyword()) :: result()
  def weather_alerts(
        %Config{} = config,
        latitude,
        longitude,
        country_code,
        opts \\ []
      )
      when is_latitude(latitude) and is_longitude(longitude) do
    path = build_weather_path(latitude, longitude, opts)
    params = build_weather_params([data_sets: "weatherAlerts", countryCode: country_code], opts)
    Request.get(config, path, params)
  end

  @doc """
  Obtains data sets for the requested location in batch.

  ## Options

    * #{@doc_language}
    * #{@doc_timezone}
    * #{@doc_current_as_of}
    * #{@doc_daily_start}
    * #{@doc_daily_end}
    * #{@doc_hourly_start}
    * #{@doc_hourly_end}
    * #{@doc_country_code}

  ## Examples

      Apple.WeatherKit.weather_batch(config, 27.637, 120.699, ["currentWeather", "forecastDaily", "forecastHourly"])

  """
  @spec weather_batch(Config.t(), latitude(), longitude(), data_sets(), keyword()) :: result()
  def weather_batch(%Config{} = config, latitude, longitude, data_sets, opts \\ [])
      when is_latitude(latitude) and is_longitude(longitude) and is_list(data_sets) do
    path = build_weather_path(latitude, longitude, opts)
    params = build_weather_params([data_sets: Enum.join(data_sets, ",")], opts)
    Request.get(config, path, params)
  end

  defp build_weather_path(latitude, longitude, opts) do
    language = Keyword.get(opts, :language, "en")
    "/api/v1/weather/#{language}/#{latitude}/#{longitude}"
  end

  defp build_weather_params(opts, extra_opts) do
    opts
    |> Keyword.delete(:language)
    |> Keyword.put_new(:timezone, "Etc/UTC")
    |> Keyword.merge(extra_opts)
    |> camel_case()
  end

  defp camel_case([]), do: []

  defp camel_case([{_, _} | _] = kvs) do
    Enum.map(kvs, fn {k, v} ->
      {CozyCase.camel_case(k), v}
    end)
  end

  @doc """
  Obtains attribution information.
  """
  @spec attribution(Config.t(), language()) :: result()
  def attribution(%Config{} = config, language) do
    path = "/attribution/#{language}"
    Request.get(config, path)
  end
end

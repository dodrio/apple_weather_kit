defmodule Apple.WeatherKit.I18n do
  @moduledoc """
  Provides utilities for i18n.
  """

  @type condition_code :: String.t()
  @type locale :: String.t()

  @doc """
  Gets the localized name of an condition code.

  > Currently, only limited locales (`"en"`, `"zh-Hans"`, `"zh-Hant"`) are
  > supported, If you want to get support for more locales, or improve the
  > existing locales, consider to contribute.

  ## Examples

      iex> Apple.WeatherKit.I18n.condition_name("MostlyCloudy", "en")
      {:ok, "Mostly Cloudy"}

      iex> Apple.WeatherKit.I18n.condition_name("MostlyCloudy", "zh-Hans")
      {:ok, "大部多云"}

      iex> Apple.WeatherKit.I18n.condition_name("unknown condition code", "en")
      :error

      iex> Apple.WeatherKit.I18n.condition_name("MostlyCloudy", "unknown locale")
      :error

  """
  @spec condition_name(condition_code(), locale()) :: {:ok, String.t()} | :error

  @raw_data_dir Path.join(:code.priv_dir(:apple_weather_kit), "i18n")
  # These codes may run slowly, but fortunately, they run at compile time.
  @raw_data_dir
  |> Path.join("*")
  |> Path.wildcard()
  |> Enum.map(fn path ->
    locale = Path.basename(path, ".txt")
    content = File.read!(path)

    conditions =
      content
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.split(&1, ~r"\s*,\s*", trim: true))

    %{
      locale: locale,
      conditions: conditions
    }
  end)
  |> Enum.reduce([], fn %{locale: locale, conditions: conditions}, acc ->
    localized_conditions =
      for [code, name] <- conditions do
        {locale, code, name}
      end

    Enum.concat(acc, localized_conditions)
  end)
  |> Enum.each(fn {locale, code, name} ->
    def condition_name(unquote(code), unquote(locale)), do: {:ok, unquote(name)}
  end)

  def condition_name(_, _) do
    :error
  end
end

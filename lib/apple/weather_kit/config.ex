defmodule Apple.WeatherKit.ConfigError do
  defexception [:message]
end

defmodule Apple.WeatherKit.Config do
  @moduledoc """
  Builds ~%Config{}~ struct with necessary options.
  """

  @schema [
    team_id: [
      type: :string,
      required: true
    ],
    service_id: [
      type: :string,
      required: true
    ],
    key_id: [
      type: :string,
      required: true
    ],
    private_key: [
      type: :string,
      required: true
    ]
  ]

  @enforce_keys Keyword.keys(@schema)
  defstruct @enforce_keys

  def new(options) when is_list(options) do
    case NimbleOptions.validate(options, @schema) do
      {:ok, validated_options} ->
        {:ok, struct!(__MODULE__, validated_options)}

      {:error, %NimbleOptions.ValidationError{message: message}} ->
        {:ok, %Apple.WeatherKit.ConfigError{message: message}}
    end
  end

  def new!(options) when is_list(options) do
    case new(options) do
      {:ok, config} -> config
      {:error, error} -> raise error
    end
  end
end

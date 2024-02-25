defmodule Apple.WeatherKit.ConfigError do
  defexception [:message]
end

defmodule Apple.WeatherKit.Config do
  @moduledoc """
  Builds ~%Config{}~ struct with required options.

  ## `team_id`

  The 10-character Team ID from your developer account.

  ## `service_id`

  The registered Service ID, like `"com.example.weatherkit-client"`.

  ## `key_id`

  A 10-character private key identifier you obtain from your developer account.

  ## `private_key`

  The content of private key which is downloaded from your developer account,
  like:

  ```
  -----BEGIN PRIVATE KEY-----
  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  xxxxxxxxx
  -----END PRIVATE KEY-----
  ```

  ## But, how to get these values?

  Read ["Create a private key and Service ID" section of Request authentication for WeatherKit REST API]
  (<https://developer.apple.com/documentation/weatherkitrestapi/request_authentication_for_weatherkit_rest_api#4042234>)
  for more details.

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

  @type t :: %__MODULE__{
          team_id: String.t(),
          service_id: String.t(),
          key_id: String.t(),
          private_key: String.t()
        }

  def new(options) when is_list(options) do
    case NimbleOptions.validate(options, @schema) do
      {:ok, validated_options} ->
        {:ok, struct!(__MODULE__, validated_options)}

      {:error, %NimbleOptions.ValidationError{message: message}} ->
        {:error, %Apple.WeatherKit.ConfigError{message: message}}
    end
  end

  def new!(options) when is_list(options) do
    case new(options) do
      {:ok, config} -> config
      {:error, exception} -> raise exception
    end
  end
end

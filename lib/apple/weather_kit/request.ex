defmodule Apple.WeatherKit.RequestError do
  defexception [:message, :reason]
end

defmodule Apple.WeatherKit.Request do
  @moduledoc """
  Provides basic HTTP request utilities.

  References:

    * [Request authentication for WeatherKit REST API](https://developer.apple.com/documentation/weatherkitrestapi/request_authentication_for_weatherkit_rest_api)

  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.WeatherKit.Config
  alias Apple.WeatherKit.RequestError

  @version Apple.WeatherKit.MixProject.project()[:version]

  def get(config, path, params \\ []) do
    base_url = "https://weatherkit.apple.com"
    headers = build_headers(config)

    Req.request(
      method: :get,
      base_url: base_url,
      url: path,
      params: params,
      headers: headers
    )
    |> case do
      {:ok, %Req.Response{status: status, body: body}} ->
        handle_response(status, body)

      {:error, exception} ->
        {:error, exception}
    end
  end

  defp build_headers(%Config{} = config) do
    %{
      "Authorization" => "Bearer #{build_token(config)}",
      "User-Agent" => "Apple.WeatherKit v#{@version}"
    }
  end

  defp handle_response(200, body) do
    {:ok, body}
  end

  defp handle_response(400, _body) do
    {:error,
     %RequestError{
       reason: :bad_request,
       message: "The server is unable to process the request due to an invalid parameter value."
     }}
  end

  defp handle_response(401, _body) do
    {:error,
     %RequestError{
       reason: :unauthorized,
       message:
         "The request isn't authorized or doesn't include the correct authentication information."
     }}
  end

  defp handle_response(403, _body) do
    {:error,
     %RequestError{
       reason: :forbidden,
       message: "The request is forbidden."
     }}
  end

  defp handle_response(404, _body) do
    {:error,
     %RequestError{
       reason: :not_found,
       message: "The requested data is not found."
     }}
  end

  defp build_token(%Config{} = config) do
    issued_at = unix_time_in_seconds()
    expired_at = issued_at + 60

    header = %{
      "alg" => "ES256",
      "kid" => config.key_id,
      "id" => "#{config.team_id}.#{config.service_id}"
    }

    payload = %{
      "iss" => config.team_id,
      "iat" => issued_at,
      "exp" => expired_at,
      "sub" => config.service_id
    }

    jwk = JWK.from_pem(config.private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(payload)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end

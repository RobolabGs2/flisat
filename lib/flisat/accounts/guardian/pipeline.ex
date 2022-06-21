defmodule Flisat.Accounts.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :flisat,
    error_handler: Flisat.Accounts.Guardian.ErrorHandler,
    module: Flisat.Accounts.Services.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end

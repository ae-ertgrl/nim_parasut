import std/json

type
  ParasutAuthError* = object of CatchableError
  ParasutApiError* = object of CatchableError
  ParasutValidationError* = object of CatchableError

  OAuthToken* = object
    access_token*: string
    token_type*: string
    expires_in*: int
    refresh_token*: string
    scope*: string
    created_at*: int

  Meta* = object
    current_page*: int
    total_pages*: int
    total_count*: int
    per_page*: int

  ResponseData*[T] = object
    data*: T
    meta*: Meta
    included*: JsonNode

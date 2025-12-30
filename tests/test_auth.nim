import unittest, asyncdispatch, json, options
import nim_parasut

suite "Authentication Tests":
  test "Can initialize client":
    let client = initParasutClient(
      "test_id", "test_secret", "user", "pass", "12345"
    )
    check client.clientId == "test_id"
    check client.companyId == "12345"

  test "Client request throws without token (and no network)":
    let client = initParasutClient(
      "test_id", "test_secret", "user", "pass", "12345"
    )
    # This will fail because it tries to authenticate and network is mocked/unavailable or will error out
    # Ideally we'd mock the HTTP client, but std/httpclient is hard to mock directly without dependency injection or interface.
    # We will just check that it TRIES to authenticate (by checking side effects or errors).

    expect Exception:
      discard waitFor client.request("GET", "me")

import nim_parasut
import std/[asyncdispatch, os, strformat, json, options]

proc main() {.async.} =
  # 1. Setup Client
  let client = initParasutClient(
    clientId = getEnv("PARASUT_CLIENT_ID", "your_client_id"),
    clientSecret = getEnv("PARASUT_CLIENT_SECRET", "your_client_secret"),
    username = getEnv("PARASUT_USERNAME", "your_username"),
    password = getEnv("PARASUT_PASSWORD", "your_password"),
    companyId = getEnv("PARASUT_COMPANY_ID", "your_company_id")
  )

  # 2. Define Hooks
  client.onLog = proc(msg: string, level: string) =
    echo &"[LOG {level}]: {msg}"

  client.onResponse = proc(endpoint: string, payload: JsonNode) =
    # In a real app, you might save this to a 'api_logs' table in Postgres
    echo &"Captured response from: {endpoint}"

  try:
    # 3. Authenticate
    await client.authenticate()

    # 4. Fetch Contacts
    echo "Fetching contacts..."
    let contacts = await client.listContacts()
    for c in contacts:
      echo &" - {c.attributes.name} ({c.attributes.email})"

    # 5. Create a Product
    echo "Creating a new product..."
    let productInput = ProductInput(
      `type`: "products",
      attributes: ProductAttributes(
        name: "Consulting Service",
        vat_rate: 18.0,
        currency: "TRL",
        list_price: 1000.0,
        unit: "unit",
        inventory_tracking: false
      )
    )
    let product = await client.createProduct(productInput)
    echo &"Created Product: {product.attributes.name} (ID: {product.id})"

  except ParasutAuthError as e:
    echo "Authentication failed: ", e.msg
  except ParasutApiError as e:
    echo "API Error: ", e.msg
  except Exception as e:
    echo "Unexpected error: ", e.msg

when isMainModule:
  waitFor main()

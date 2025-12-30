# nim_parasut

A production-ready Nim client for the [Paraşüt Accounting API](https://apidocs.parasut.com/).

This package provides a high-performance, async-first, and type-safe wrapper for the Paraşüt API, suitable for multi-tenant applications.

## Features

*   **Async-First:** Built with `std/asyncdispatch` and `std/httpclient` for non-blocking I/O.
*   **Multi-Tenancy:** Helper object `ParasutClient` holds state, allowing multiple instances for different firms.
*   **Auth Handling:** Implements OAuth2 Password Grant with **Auto-Refresh** mechanism.
*   **Hooks System:** `onLog` and `onResponse` callbacks for easy integration with your own logging or DB system.
*   **Modular Architecture:** Services (Contacts, Products, Invoices, E-Archives) are separated for maintainability.
*   **Full CRUD:** Supports Create, Read, Update, Delete (and Cancel) operations.

## Installation

Add to your `.nimble` file:

```nim
requires "nim_parasut"
```

Or install via nimble (once published):

```bash
nimble install nim_parasut
```

## Usage

### 1. Initialization

Initialize the client with your credentials. You can load these from environment variables or a config file.

```nim
import nim_parasut, std/[asyncdispatch, os]

let client = initParasutClient(
  clientId = getEnv("PARASUT_CLIENT_ID"),
  clientSecret = getEnv("PARASUT_CLIENT_SECRET"),
  username = getEnv("PARASUT_USERNAME"),
  password = getEnv("PARASUT_PASSWORD"),
  companyId = getEnv("PARASUT_COMPANY_ID")
)
```

### 2. Hooks (Logging & auditing)

Inject your own logic to handle logs and raw responses.

```nim
import std/[strformat, json]

client.onLog = proc(msg: string, level: string) =
  echo &"[{level}] {msg}"

client.onResponse = proc(endpoint: string, payload: JsonNode) =
  # Save payload to DB or file
  echo &"Received response from {endpoint}"
```

### 3. Fetching Data

Use the service procedures to interact with the API.

```nim
# Authenticate (optional, request will auto-auth if needed)
await client.authenticate()

# List Contacts
let contacts = await client.listContacts()
for contact in contacts:
  echo contact.attributes.name

# Create an Invoice
import std/options

let newInvoice = SalesInvoiceInput(
  `type`: "sales_invoices",
  attributes: SalesInvoiceAttributes(
    item_type: "invoice",
    issue_date: "2023-10-27",
    currency: "TRL",
    exchange_rate: 1.0,
    total_vat: 90.0,
    total_gross: 590.0
  ),
  relationships: %* {
    "contact": { "data": { "id": "contact_id", "type": "contacts" } }
    # ... details ...
  }
)

let invoice = await client.createSalesInvoice(newInvoice)
echo "Created invoice: ", invoice.id
```

### 4. Pagination

The `fetchAllItems` helper automatically handles pagination for you.

```nim
# Fetches ALL products, handling pagination internally
let allProducts = await client.fetchAllItems("products")
```

## Testing

Run unit tests:

```bash
nim c -r tests/test_auth.nim
nim c -r tests/test_services.nim
```

Run integration tests (requires `.env` vars set):

```bash
nim c -r tests/integration_sandbox.nim
```

## License

MIT

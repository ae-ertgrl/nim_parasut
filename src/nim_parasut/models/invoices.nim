import std/[options, json]

type
  SalesInvoiceDetailAttributes* = object
    quantity*: float
    unit_price*: float
    vat_rate*: float
    description*: Option[string]

  SalesInvoiceDetail* = object
    `type`*: string
    attributes*: SalesInvoiceDetailAttributes
    relationships*: Option[JsonNode] # For product relationship

  SalesInvoiceAttributes* = object
    item_type*: string
    description*: Option[string]
    issue_date*: string
    due_date*: Option[string]
    invoice_series*: Option[string]
    invoice_id*: Option[int]
    currency*: string
    exchange_rate*: float
    total_vat*: float
    total_gross*: float

  SalesInvoice* = object
    id*: string
    `type`*: string
    attributes*: SalesInvoiceAttributes
    relationships*: JsonNode

  SalesInvoiceInput* = object
    `type`*: string
    attributes*: SalesInvoiceAttributes
    relationships*: JsonNode

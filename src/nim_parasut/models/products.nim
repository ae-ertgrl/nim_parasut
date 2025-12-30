import std/options

type
  ProductAttributes* = object
    code*: Option[string]
    name*: string
    vat_rate*: float
    currency*: string
    list_price*: float
    unit*: string
    communications_tax_rate*: Option[float]
    inventory_tracking*: bool

  Product* = object
    id*: string
    `type`*: string
    attributes*: ProductAttributes

  ProductInput* = object
    `type`*: string
    attributes*: ProductAttributes

import std/options

type
  ContactAttributes* = object
    name*: string
    email*: Option[string]
    tax_number*: Option[string]
    tax_office*: Option[string]
    city*: Option[string]
    district*: Option[string]
    address*: Option[string]
    phone*: Option[string]
    contact_type*: string # "person" or "company"
    is_abroad*: bool
    iban*: Option[string]
    account_type*: string # "customer", "supplier"

  Contact* = object
    id*: string
    `type`*: string
    attributes*: ContactAttributes

  ContactInput* = object
    `type`*: string
    attributes*: ContactAttributes

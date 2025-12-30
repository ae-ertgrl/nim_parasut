import std/options

type
  EArchiveAttributes* = object
    uuid*: string
    invoice_number*: string
    note*: Option[string]
    pdf_url*: Option[string]
    xml_url*: Option[string]

  EArchive* = object
    id*: string
    `type`*: string
    attributes*: EArchiveAttributes

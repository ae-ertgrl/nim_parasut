import std/[json, asyncdispatch, options, strformat]
import ../client
import ../models/e_archives
import ../models/common

# E-Archives are typically created from Sales Invoices, so 'create' might mean 'convert to e-archive'
# Usually: POST /e_archives (with invoice_id)

type EArchiveInput* = object
  `type`*: string
  relationships*: JsonNode # Should contain sales_invoice relationship

proc createEArchive*(client: ParasutClient, eArchive: EArchiveInput): Future[EArchive] {.async.} =
  let payload = %*{
    "data": {
      "type": eArchive.`type`,
      "relationships": eArchive.relationships
    }
  }
  let resp = await client.request("POST", "e_archives", body = payload)
  return resp["data"].to(EArchive)

proc listEArchives*(client: ParasutClient, query: openArray[(string, string)] = []): Future[seq[EArchive]] {.async.} =
  let items = await client.fetchAllItems("e_archives", query)
  result = @[]
  for item in items:
    result.add(item.to(EArchive))

proc getEArchive*(client: ParasutClient, id: string): Future[EArchive] {.async.} =
  let resp = await client.request("GET", &"e_archives/{id}")
  return resp["data"].to(EArchive)

# E-Archives usually can't be updated once created/sent, but we can check PDF/XML status
proc getEArchivePdf*(client: ParasutClient, id: string): Future[string] {.async.} =
  # Depending on API, this might return a URL or binary content.
  # The model has pdf_url.
  let archive = await client.getEArchive(id)
  if archive.attributes.pdf_url.isSome:
    return archive.attributes.pdf_url.get
  else:
    raise newException(ParasutApiError, "PDF URL not available")

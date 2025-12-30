import std/[json, asyncdispatch, options, strformat]
import ../client
import ../models/invoices
import ../models/common

proc createSalesInvoice*(client: ParasutClient, invoice: SalesInvoiceInput): Future[SalesInvoice] {.async.} =
  let payload = %*{
    "data": {
      "type": invoice.`type`,
      "attributes": invoice.attributes,
      "relationships": invoice.relationships
    }
  }
  let resp = await client.request("POST", "sales_invoices", body = payload)
  return resp["data"].to(SalesInvoice)

proc listSalesInvoices*(client: ParasutClient, query: openArray[(string, string)] = []): Future[seq[SalesInvoice]] {.async.} =
  let items = await client.fetchAllItems("sales_invoices", query)
  result = @[]
  for item in items:
    result.add(item.to(SalesInvoice))

proc getSalesInvoice*(client: ParasutClient, id: string): Future[SalesInvoice] {.async.} =
  let resp = await client.request("GET", &"sales_invoices/{id}")
  return resp["data"].to(SalesInvoice)

proc updateSalesInvoice*(client: ParasutClient, id: string, invoice: SalesInvoiceInput): Future[SalesInvoice] {.async.} =
  let payload = %*{
    "data": {
      "type": invoice.`type`,
      "attributes": invoice.attributes,
      "relationships": invoice.relationships
    }
  }
  let resp = await client.request("PUT", &"sales_invoices/{id}", body = payload)
  return resp["data"].to(SalesInvoice)

proc cancelSalesInvoice*(client: ParasutClient, id: string): Future[void] {.async.} =
  discard await client.request("DELETE", &"sales_invoices/{id}")

proc paySalesInvoice*(client: ParasutClient, id: string): Future[void] {.async.} =
   # Paying an invoice usually involves creating a payment transaction linked to it,
   # but explicitly 'paying' via PUT status might be what's needed or creating a payment record.
   # Based on API docs, typically one creates a payment.
   # For now, let's implement a 'pay' action if there is a specific endpoint or just leave it for payments service.
   # The user asked for "Full CRUD", so cancel/delete is covered.
   raise newException(ValueError, "Payment logic not implemented yet. Use 'createPayment' (to be implemented) instead.")

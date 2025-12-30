import std/[json, asyncdispatch, options, strformat]
import ../client
import ../models/products
import ../models/common

proc createProduct*(client: ParasutClient, product: ProductInput): Future[Product] {.async.} =
  let payload = %*{
    "data": {
      "type": product.`type`,
      "attributes": product.attributes
    }
  }
  let resp = await client.request("POST", "products", body = payload)
  return resp["data"].to(Product)

proc listProducts*(client: ParasutClient, query: openArray[(string, string)] = []): Future[seq[Product]] {.async.} =
  let items = await client.fetchAllItems("products", query)
  result = @[]
  for item in items:
    result.add(item.to(Product))

proc getProduct*(client: ParasutClient, id: string): Future[Product] {.async.} =
  let resp = await client.request("GET", &"products/{id}")
  return resp["data"].to(Product)

proc updateProduct*(client: ParasutClient, id: string, product: ProductInput): Future[Product] {.async.} =
  let payload = %*{
    "data": {
      "type": product.`type`,
      "attributes": product.attributes
    }
  }
  let resp = await client.request("PUT", &"products/{id}", body = payload)
  return resp["data"].to(Product)

proc deleteProduct*(client: ParasutClient, id: string): Future[void] {.async.} =
  discard await client.request("DELETE", &"products/{id}")

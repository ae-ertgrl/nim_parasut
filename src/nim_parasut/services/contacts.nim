import std/[json, asyncdispatch, options, strformat]
import ../client
import ../models/contacts
import ../models/common

proc createContact*(client: ParasutClient, contact: ContactInput): Future[Contact] {.async.} =
  let payload = %*{
    "data": {
      "type": contact.`type`,
      "attributes": contact.attributes
    }
  }
  let resp = await client.request("POST", "contacts", body = payload)
  return resp["data"].to(Contact)

proc listContacts*(client: ParasutClient, query: openArray[(string, string)] = []): Future[seq[Contact]] {.async.} =
  let items = await client.fetchAllItems("contacts", query)
  result = @[]
  for item in items:
    result.add(item.to(Contact))

proc getContact*(client: ParasutClient, id: string): Future[Contact] {.async.} =
  let resp = await client.request("GET", &"contacts/{id}")
  return resp["data"].to(Contact)

proc updateContact*(client: ParasutClient, id: string, contact: ContactInput): Future[Contact] {.async.} =
  let payload = %*{
    "data": {
      "type": contact.`type`,
      "attributes": contact.attributes
    }
  }
  let resp = await client.request("PUT", &"contacts/{id}", body = payload)
  return resp["data"].to(Contact)

proc deleteContact*(client: ParasutClient, id: string): Future[void] {.async.} =
  discard await client.request("DELETE", &"contacts/{id}")

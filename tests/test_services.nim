import unittest, asyncdispatch, json, options
import nim_parasut

# Mocking responses would require a more advanced HTTP client setup or wrapper.
# For unit tests here, we check object mapping logic.

suite "Service Object Mapping Tests":
  test "Contact attributes mapping":
    let jsonNode = parseJson("""
      {
        "id": "1",
        "type": "contacts",
        "attributes": {
          "name": "Test Company",
          "email": "test@example.com",
          "contact_type": "company",
          "is_abroad": false,
          "account_type": "customer"
        }
      }
    """)
    let contact = jsonNode.to(Contact)
    check contact.id == "1"
    check contact.attributes.name == "Test Company"
    check contact.attributes.email == some("test@example.com")

  test "Product attributes mapping":
    let jsonNode = parseJson("""
      {
        "id": "100",
        "type": "products",
        "attributes": {
          "name": "Service Item",
          "vat_rate": 18.0,
          "currency": "TRL",
          "list_price": 100.0,
          "unit": "unit",
          "inventory_tracking": false
        }
      }
    """)
    let prod = jsonNode.to(Product)
    check prod.id == "100"
    check prod.attributes.list_price == 100.0

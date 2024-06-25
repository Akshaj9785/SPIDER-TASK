mongo
use inventoryDB
db.createCollection("products")
db.products.insertMany([
    {
      name: "Product1",
      description: "Description of product 1",
      price: 100.00,
      quantity: 50,
      category: "Category1"
    },
    {
      name: "Product2",
      description: "Description of product 2",
      price: 200.00,
      quantity: 30,
      category: "Category2"
    },
    {
      name: "Product3",
      description: "Description of product 3",
      price: 150.00,
      quantity: 20,
      category: "Category3"
    },
    {
      name: "Product4",
      description: "Description of product 4",
      price: 250.00,
      quantity: 10,
      category: "Category4"
    },
    {
      name: "Product5",
      description: "Description of product 5",
      price: 300.00,
      quantity: 60,
      category: "Category5"
    }
  ])
  
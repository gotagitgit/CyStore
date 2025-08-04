var builder = DistributedApplication.CreateBuilder(args);

// Add the microservices
var accountService = builder.AddProject<Projects.AccountService>("accountservice")
    .WithHttpEndpoint(port: 8081, name: "account-http");

var inventoryService = builder.AddProject<Projects.InventoryService>("inventoryservice")
    .WithHttpEndpoint(port: 8082, name: "inventory-http");

var shoppingService = builder.AddProject<Projects.ShoppingService>("shoppingservice")
    .WithHttpEndpoint(port: 8083, name: "shopping-http");

// Add the React web application
//builder.AddProject<Projects.Store_Web>("store2018")
//    .WithHttpEndpoint(port: 5000, name: "http")
builder.AddProject<Projects.store_reactweb>("store-reactweb")
    .WithHttpEndpoint(port: 5000, name: "frontend-http")
    .WithReference(accountService)
    .WithReference(inventoryService)
    .WithReference(shoppingService);

builder.Build().Run();

var builder = DistributedApplication.CreateBuilder(args);

// Add the microservices
var accountService = builder.AddProject<Projects.AccountService>("accountservice")
    .WithHttpEndpoint(port: 8081, name: "http");

var inventoryService = builder.AddProject<Projects.InventoryService>("inventoryservice")
    .WithHttpEndpoint(port: 8082, name: "http");

var shoppingService = builder.AddProject<Projects.ShoppingService>("shoppingservice")
    .WithHttpEndpoint(port: 8083, name: "http");

// Add the main web application
builder.AddProject<Projects.Store_Web>("store2018")
    .WithHttpEndpoint(port: 5000, name: "http")
    .WithReference(accountService)
    .WithReference(inventoryService)
    .WithReference(shoppingService);

builder.Build().Run();

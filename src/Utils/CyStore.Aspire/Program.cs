var builder = DistributedApplication.CreateBuilder(args);

// Add the microservices
var accountService = builder.AddProject<Projects.AccountService>("accountservice")
    .WithHttpEndpoint(port: 8081, name: "http");

var inventoryService = builder.AddProject<Projects.InventoryService>("inventoryservice")
    .WithHttpEndpoint(port: 8082, name: "http");

var shoppingService = builder.AddProject<Projects.ShoppingService>("shoppingservice")
    .WithHttpEndpoint(port: 8083, name: "http");

// Add the React web store
builder.AddExecutable("store-reactweb", "npm", "../../Store/store.webreact", "run", "dev")
        .WithReference(accountService)
        .WithReference(inventoryService)
        .WithReference(shoppingService)
        .WaitFor(shoppingService)
        .WaitFor(inventoryService)
        .WaitFor(accountService)
        .WithExternalHttpEndpoints();


builder.Build().Run();

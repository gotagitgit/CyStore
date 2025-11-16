@echo off
echo Building all Docker images...

docker build -t theeknockdocker/cystore-accountservice:latest -f src/Store/AccountService/Dockerfile .
docker build -t theeknockdocker/cystore-inventoryservice:latest -f src/Store/InventoryService/Dockerfile .
docker build -t theeknockdocker/cystore-shoppingservice:latest -f src/Store/ShoppingService/Dockerfile .
docker build -t theeknockdocker/cystore-storereact:latest -f src/Store/store.webreact/Dockerfile .

echo All images built successfully!
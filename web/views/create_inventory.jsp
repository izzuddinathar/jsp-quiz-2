<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Inventory</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Inventory</h1>
        <form action="<%= request.getContextPath() %>/create_inventory" method="post">
            <div class="mb-3">
                <label for="nama_bahan_pokok" class="form-label">Item Name</label>
                <input type="text" class="form-control" id="nama_bahan_pokok" name="nama_bahan_pokok" required>
            </div>
            <div class="mb-3">
                <label for="jumlah" class="form-label">Quantity</label>
                <input type="number" class="form-control" id="jumlah" name="jumlah" required>
            </div>
            <div class="mb-3">
                <label for="satuan" class="form-label">Unit</label>
                <input type="text" class="form-control" id="satuan" name="satuan" required>
            </div>
            <div class="mb-3">
                <label for="supplier" class="form-label">Supplier</label>
                <input type="text" class="form-control" id="supplier" name="supplier" required>
            </div>
            <button type="submit" class="btn btn-primary">Add Item</button>
        </form>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Table</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Table</h1>
        <form action="<%= request.getContextPath() %>/create_table" method="post">
            <div class="mb-3">
                <label for="nomor_meja" class="form-label">Table Number</label>
                <input type="number" class="form-control" id="nomor_meja" name="nomor_meja" required>
            </div>
            <div class="mb-3">
                <label for="kapasitas" class="form-label">Capacity</label>
                <input type="number" class="form-control" id="kapasitas" name="kapasitas" required>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="tersedia">Tersedia</option>
                    <option value="dipesan">Dipesan</option>
                    <option value="terisi">Terisi</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Table</button>
        </form>
    </div>
</body>
</html>

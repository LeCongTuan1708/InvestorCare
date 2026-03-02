<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Ticker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        /* Tinh chỉnh thêm để màu sắc thật sự chuẩn Dark Tech */
        body { background-color: #000000; }
        .card { background-color: #0b0c0d !important; }
        .form-control, .form-select { background-color: #1a1d20 !important; border-color: #373b3e !important; }
        .form-control:focus, .form-select:focus { box-shadow: 0 0 0 0.25rem rgba(13, 202, 240, 0.25); border-color: #0dcaf0 !important; }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card border-secondary shadow-lg rounded-3">
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="add-asset">
                        
                        <div class="card-header bg-transparent py-4 border-bottom border-secondary">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h2 class="mb-0 fw-bold text-info text-uppercase">
                                        <i class="bi bi-plus-circle me-2"></i>Add New Ticker
                                    </h2>
                                </div>
                                <div class="col-auto">
                                    <button type="button" class="btn btn-outline-secondary px-4 me-2 fw-bold" onclick="history.back()">
                                        CANCEL
                                    </button>
                                    <button type="submit" class="btn btn-info px-4 fw-bold text-dark">
                                        CREATE TICKER
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-4 p-md-5">
                            <p class="fw-bold text-info mb-4 border-start border-3 border-info ps-2 text-uppercase">Ticker Configuration</p>
                            
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-secondary text-uppercase">Symbol</label>
                                    <input type="text" name="symbol" class="form-control form-control-lg text-info fw-bold" 
                                           placeholder="e.g. AAPL, BTC" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-secondary text-uppercase">Name (Asset/Company)</label>
                                    <input type="text" name="name" class="form-control form-control-lg text-light" 
                                           placeholder="e.g. Apple Inc." required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-secondary text-uppercase">Type</label>
                                    <select name="type" class="form-select form-select-lg text-light">
                                        <option value="STOCK">STOCK</option>
                                        <option value="GOLD">GOLD</option>
                                        <option value="SILVER">SILVER</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-secondary text-uppercase">Exchange</label>
                                    <input type="text" name="exchange" class="form-control form-control-lg text-light" 
                                           placeholder="e.g. NASDAQ, HOSE">
                                </div>

                                <div class="col-12 mt-5">
                                    <div class="p-3 rounded bg-black border border-secondary text-center">
                                        <p class="small text-secondary mb-0">
                                            <i class="bi bi-info-circle me-2"></i>New tickers will be set to 
                                            <span class="text-warning fw-bold">Hidden</span> and 
                                            <span class="text-info fw-bold">Active</span> by default.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : "ShopSphere - Modern Online Shopping"}</title>
    <!-- High-Performance Resource Hints -->
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="dns-prefetch" href="https://images.unsplash.com">
    <link rel="preconnect" href="https://images.unsplash.com" crossorigin>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --brand-primary: #059669;
            --brand-primary-light: #10b981;
            --brand-primary-dark: #047857;
            --brand-accent: #f59e0b;
            --brand-dark: #0f172a;
            --brand-slate: #1e293b;
            --brand-bg: #f8fafc;
        }
        body {
            font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: var(--brand-bg);
            color: #1e293b;
        }
        .main-content {
            flex: 1 0 auto;
        }
        /* Custom Modern Navbar */
        .navbar-custom {
            background-color: var(--brand-dark) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }
        /* Brand Colors & Overrides */
        .text-primary {
            color: var(--brand-primary-light) !important;
        }
        .bg-primary {
            background-color: var(--brand-primary) !important;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--brand-primary-light) 0%, var(--brand-primary) 100%);
            border: none;
            color: #ffffff;
            font-weight: 600;
            transition: all 0.25s ease;
            box-shadow: 0 2px 6px rgba(16, 185, 129, 0.25);
        }
        .btn-primary:hover, .btn-primary:focus {
            background: linear-gradient(135deg, var(--brand-primary) 0%, var(--brand-primary-dark) 100%);
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        .btn-warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            border: none;
            color: #ffffff !important;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(245, 158, 11, 0.25);
        }
        .btn-warning:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
        }
        /* Product Cards */
        .product-card {
            border-radius: 0.85rem;
            border: 1px solid #e2e8f0;
            background: #ffffff;
            transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 28px -6px rgba(15, 23, 42, 0.12), 0 4px 8px -4px rgba(15, 23, 42, 0.05) !important;
            border-color: #cbd5e1;
        }
        /* Modern Hero Banner */
        .hero-banner {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #064e3b 100%);
            color: white;
            border-radius: 1.25rem;
            border: 1px solid rgba(16, 185, 129, 0.2);
            box-shadow: 0 15px 35px -10px rgba(5, 150, 105, 0.3);
        }
        /* Active list items */
        .list-group-item.active {
            background: linear-gradient(135deg, var(--brand-primary-light) 0%, var(--brand-primary) 100%) !important;
            border-color: var(--brand-primary) !important;
        }
        /* Badges */
        .badge.bg-primary {
            background: linear-gradient(135deg, var(--brand-primary-light) 0%, var(--brand-primary) 100%) !important;
        }
    </style>
</head>
<body>
<div class="main-content">

# 📊 Dbt Data Warehouse Modeling

[![SQL](https://img.shields.io/badge/SQL-Standard-336791.svg)](https://www.iso.org/standard/76583.html)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[English](#english) | [Português](#português)

---

## English

### 🎯 Overview

**Dbt Data Warehouse Modeling** — Data warehouse modeling project using dbt (data build tool). Implements dimensional modeling, data marts, and automated testing for analytics-ready data transformations.

Total source lines: **763** across **18** files in **1** language.

### ✨ Key Features

- **Production-Ready Architecture**: Modular, well-documented, and following best practices
- **Comprehensive Implementation**: Complete solution with all core functionality
- **Clean Code**: Type-safe, well-tested, and maintainable codebase
- **Easy Deployment**: Docker support for quick setup and deployment

### 🚀 Quick Start

#### Prerequisites
- See requirements below


#### Installation

1. **Clone the repository**
```bash
git clone https://github.com/galafis/dbt-data-warehouse-modeling.git
cd dbt-data-warehouse-modeling
```








### 📁 Project Structure

```
dbt-data-warehouse-modeling/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DATA_FLOW.md
│   ├── FAQ.md
│   └── TROUBLESHOOTING.md
├── images/
├── macros/
│   ├── tests/
│   │   └── accepted_range.sql
│   ├── cents_to_dollars.sql
│   ├── generate_schema_name.sql
│   └── surrogate_key.sql
├── models/
│   ├── intermediate/
│   │   ├── _intermediate.yml
│   │   ├── int_customer_metrics.sql
│   │   └── int_orders_enriched.sql
│   ├── marts/
│   │   ├── core/
│   │   └── metrics/
│   └── staging/
│       ├── _staging.yml
│       ├── stg_customers.sql
│       ├── stg_orders.sql
│       └── stg_products.sql
├── seeds/
├── snapshots/
│   └── orders_snapshot.sql
├── tests/
│   ├── assert_customers_have_orders.sql
│   ├── assert_positive_revenue.sql
│   └── assert_valid_dates.sql
├── CONTRIBUTING.md
├── INSTALL.md
├── README.md
└── dbt_project.yml
```

### 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| SQL | 18 files |

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 👤 Author

**Gabriel Demetrios Lafis**

- GitHub: [@galafis](https://github.com/galafis)
- LinkedIn: [Gabriel Demetrios Lafis](https://linkedin.com/in/gabriel-demetrios-lafis)

---

## Português

### 🎯 Visão Geral

**Dbt Data Warehouse Modeling** — Data warehouse modeling project using dbt (data build tool). Implements dimensional modeling, data marts, and automated testing for analytics-ready data transformations.

Total de linhas de código: **763** em **18** arquivos em **1** linguagem.

### ✨ Funcionalidades Principais

- **Arquitetura Pronta para Produção**: Modular, bem documentada e seguindo boas práticas
- **Implementação Completa**: Solução completa com todas as funcionalidades principais
- **Código Limpo**: Type-safe, bem testado e manutenível
- **Fácil Implantação**: Suporte Docker para configuração e implantação rápidas

### 🚀 Início Rápido

#### Pré-requisitos
- Veja os requisitos abaixo


#### Instalação

1. **Clone the repository**
```bash
git clone https://github.com/galafis/dbt-data-warehouse-modeling.git
cd dbt-data-warehouse-modeling
```







### 📁 Estrutura do Projeto

```
dbt-data-warehouse-modeling/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DATA_FLOW.md
│   ├── FAQ.md
│   └── TROUBLESHOOTING.md
├── images/
├── macros/
│   ├── tests/
│   │   └── accepted_range.sql
│   ├── cents_to_dollars.sql
│   ├── generate_schema_name.sql
│   └── surrogate_key.sql
├── models/
│   ├── intermediate/
│   │   ├── _intermediate.yml
│   │   ├── int_customer_metrics.sql
│   │   └── int_orders_enriched.sql
│   ├── marts/
│   │   ├── core/
│   │   └── metrics/
│   └── staging/
│       ├── _staging.yml
│       ├── stg_customers.sql
│       ├── stg_orders.sql
│       └── stg_products.sql
├── seeds/
├── snapshots/
│   └── orders_snapshot.sql
├── tests/
│   ├── assert_customers_have_orders.sql
│   ├── assert_positive_revenue.sql
│   └── assert_valid_dates.sql
├── CONTRIBUTING.md
├── INSTALL.md
├── README.md
└── dbt_project.yml
```

### 🛠️ Stack Tecnológica

| Tecnologia | Uso |
|------------|-----|
| SQL | 18 files |

### 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

### 👤 Autor

**Gabriel Demetrios Lafis**

- GitHub: [@galafis](https://github.com/galafis)
- LinkedIn: [Gabriel Demetrios Lafis](https://linkedin.com/in/gabriel-demetrios-lafis)

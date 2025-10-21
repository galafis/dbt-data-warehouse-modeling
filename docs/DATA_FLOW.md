# Data Flow Diagram

```mermaid
graph TB
    subgraph "Source Systems"
        A[Raw Orders] --> B[Staging Layer]
        C[Raw Customers] --> B
        D[Raw Products] --> B
    end
    
    subgraph "Staging Layer"
        B --> E[stg_orders]
        B --> F[stg_customers]
        B --> G[stg_products]
    end
    
    subgraph "Intermediate Layer"
        E --> H[int_orders_enriched]
        F --> H
        G --> H
        E --> I[int_customer_metrics]
    end
    
    subgraph "Marts Layer - Core"
        H --> J[fct_orders]
        F --> K[dim_customers]
        I --> K
        G --> L[dim_products]
        J --> L
    end
    
    subgraph "Marts Layer - Metrics"
        J --> M[revenue_by_month]
        K --> N[customer_cohorts]
    end
    
    subgraph "Analytics & BI"
        M --> O[Dashboards]
        N --> O
        J --> O
        K --> O
        L --> O
    end
    
    style A fill:#ff6b6b
    style C fill:#ff6b6b
    style D fill:#ff6b6b
    style E fill:#4ecdc4
    style F fill:#4ecdc4
    style G fill:#4ecdc4
    style H fill:#ffd93d
    style I fill:#ffd93d
    style J fill:#95e1d3
    style K fill:#95e1d3
    style L fill:#95e1d3
    style M fill:#a8dadc
    style N fill:#a8dadc
    style O fill:#457b9d
```

## Model Dependencies

The lineage shows how data flows through the layers:
- **Staging** models clean and standardize raw data
- **Intermediate** models add business logic and enrichment
- **Marts** models provide analytics-ready tables for BI tools

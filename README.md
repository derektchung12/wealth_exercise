# Wealth.com Analytics Engineering Take Home Skills Assessment

## Environment Setup

1. Create a Python virtual environment based on `requirements.txt` (recommended Python version is 3.12.9)

2. Run `dbt --version` to ensure dbt is installed (including DuckDB plugin). Result should look like this:

```
Core:
  - installed: 1.9.8
  - latest:    1.9.8 - Up to date!

Plugins:
  - duckdb: 1.9.3 - Up to date!
```

3. Configure your dbt `profiles.yml` file to include the DuckDB profile. It should look like this:

```yaml
dbt_takehome_project:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "./dbt_takehome.duckdb" # creates a local file in your project folder
      threads: 1
      schema: main
```

4. Run `dbt debug` and ensure it returns `All checks passed!`

## Skills Assessment

You've just joined the analytics engineering team at a growing DTC eCommerce company. The business stakeholders need trustworthy data models to answer questions about customer behavior, revenue trends, and marketing attribution.

The company tracks:

- Contacts (i.e., all marketing contacts, some of whom have completed orders and are therefore 'customers', and others who have never completed an order)
- Orders (i.e., all orders, including cancelled ones)
- Order Items (i.e., for each order, this will show the individual line items that were part of that order)
- Products (i.e., the product catalog, which can be used to understand what was included in a given order)

Your job is to model this raw data into a clean, analytics-ready set of tables that will serve as the foundation for dashboards and analysis.

### Seed Data (CSV Files)

The data for this exercise has been provided as CSV files within the `/seeds` directory. Please review the data.

### Modeling Requirements

Build the following models using dbt:

1. For each of the four seed datasets (`contacts`, `order_items`, `orders`, and `products`), build corresponding staging tables (`stg_contacts`, `stg_order_items`, `stg_orders`, and `stg_products`) in `models/staging`. Clean the column names (snake_case), cast data types appropriately, and apply lightweight data normalization (e.g., standardization of case).

2. Build an orders fact table, `fct_orders`, in the `models/intermediate` directory. Each row of this table is one order. The columns in this fact table should include:

- order_id
- contact_id
- order_date
- order_status
- total_amount
- total_quantity (i.e., total quantity of ordered items)
- list_amount (i.e., total list amount of ordered item pre-discount)
- is_discount_applied (i.e., `true` if a discount was applied on this order, `false` otherwise)

3. Add two data tests to `models/intermediate/intermediate.yml` for important data quality checks for `fct_orders`.

4. Build a dimension table, `dim_contacts`, in the `models/intermediate` directory. Each row of this table is one contact. The columns in this dimension table should include:

- contact_id
- first_name
- last_name
- total_completed_orders (i.e., where order status is completed)
- total_spend (i.e., total spend over completed orders)
- avg_order_value (i.e., average total order amount over completed orders)
- is_customer (i.e., `true` if this contact has completed at least one order, `false` otherwise)
- is_repeat_customer (i.e., `true` if this contact has completed more than one order, `false` otherwise)
- customer_since_date (i.e., when they became a customer by completing their first order)

5. Add two data tests to `models/intermediate/intermediate.yml` for important data quality checks for `dim_contacts`.

## Assessment Submission

1. Run `select \* from main.fct_orders order by order_id;`, take a screenshot, and save that screenshot to `/analysis`.

2. Run `select \* from main.dim_contacts order by contact_id;`, take a screenshot, and save that screenshot to `/analysis`.

3. Zip this entire dbt_takehome_project directory and email the .zip file to Britni Mattison.

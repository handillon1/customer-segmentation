# Customer Segmentation — Online Retail RFM Analysis

End-to-end unsupervised learning project segmenting 5,861 UK retail customers using **RFM (Recency, Frequency, Monetary)** features and **K-Means clustering**. Data flows from raw CSV → PostgreSQL → Python (scikit-learn) → Tableau dashboard.

**[View the interactive Tableau dashboard →](https://public.tableau.com/views/CustomerSegmentation-OnlineRetailRFMK-Means/Dashboard1)**

---

## Business Question

> Which customers drive the most revenue, and how can the business prioritize retention vs. reactivation efforts across distinct customer types?

## Headline Findings

- **The top 21% of customers (Champions) generate 74.5% of total revenue** — a Pareto distribution.
- **33% of the customer base (Lost) contributes only 3.6% of revenue** — predominantly one-time buyers from over a year ago.
- Four cleanly separated segments: **Champions**, **At Risk**, **New / Promising**, and **Lost**.
- PCA confirms the segments are well-separated in feature space (95.3% variance explained by 2 components).

| Segment | Customers | % of Base | % of Revenue | Avg Recency (days) | Avg Frequency | Avg Monetary (£) |
|---|---|---|---|---|---|---|
| Champions | 1,223 | 20.9% | **74.5%** | 29 | 18.9 | 10,623 |
| At Risk | 1,443 | 24.6% | 16.0% | 231 | 5.0 | 1,936 |
| New / Promising | 1,245 | 21.2% | 5.9% | 29 | 3.0 | 826 |
| Lost | 1,950 | 33.3% | 3.6% | 397 | 1.4 | 320 |

## Tools and Stack

- **PostgreSQL 16** (pgAdmin 4) — data warehousing, cleaning, and RFM feature engineering via SQL
- **Python 3 / Conda** — pandas, NumPy, scikit-learn, matplotlib, seaborn, SQLAlchemy
- **Tableau Public** — interactive dashboard with KPI tiles, segment breakdowns, RFM scatter plot, and choropleth map
- **Git / GitHub** — version control and portfolio publication

## Dataset

[UCI Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii) — transactions from a UK-based online gift retailer between 01/12/2009 and 09/12/2011. Approximately 1 million transaction line items across two years.

## Methodology

1. **Schema design** — Built `raw` and `analytics` schemas in PostgreSQL; loaded both yearly CSVs into `raw.transactions` via `COPY`.
2. **Data cleaning** — Built `analytics.clean_transactions` view excluding cancellations (invoices starting with `C`), null customer IDs, non-positive quantities/prices, and non-product stock codes (POST, BANK CHARGES, etc.).
3. **RFM feature engineering** — Built `analytics.customer_rfm` table with one row per customer including recency, frequency, monetary, average basket, and first/last purchase dates.
4. **EDA** — Examined distributions; confirmed expected right-skew in monetary and frequency. Applied `log1p` transformation prior to clustering.
5. **Outlier handling** — Capped features at the 1st and 99th percentile to limit influence of extreme wholesale customers on the K-Means centroids.
6. **Scaling** — `StandardScaler` to mean=0, std=1 across the three log-transformed RFM features.
7. **Cluster selection** — Combined elbow method (inertia) and silhouette analysis across k=2..10. Selected **k=4** (silhouette local peak of 0.372 plus elbow inflection).
8. **Final model** — `KMeans(n_clusters=4, random_state=42, n_init=10)`. Cluster labels mapped to business-meaningful segment names based on RFM profiles.
9. **Persistence** — Wrote labeled segments back to PostgreSQL as `analytics.customer_segments` and exported CSV for Tableau.
10. **Visualization** — Tableau dashboard with KPI summary, revenue and customer-count breakdown by segment, RFM scatter plot, and geographic distribution.

## Project Structure

\`\`\`
customer-segmentation/
├── README.md
├── .gitignore
├── sql/
│   ├── 01_create_schema.sql       # raw + analytics schemas, raw.transactions table
│   ├── 02_load_data.sql           # COPY both yearly CSVs into raw.transactions
│   ├── 04_clean_transactions.sql  # analytics.clean_transactions view
│   └── 05_customer_rfm.sql        # analytics.customer_rfm table
├── notebooks/
│   └── 01_eda.ipynb               # EDA, scaling, K-Means, segment labeling
├── data/                          # (gitignored) raw + processed CSVs
└── .env                           # (gitignored) PG_PASSWORD
\`\`\`

## How to Reproduce

### Prerequisites
- PostgreSQL 16 with a database named `retail`
- Anaconda / Miniconda
- Tableau Public (optional, for dashboard)

### Steps

1. **Download the dataset** from UCI and save both yearly CSVs as `retail_2009_2010.csv` and `retail_2010_2011.csv` in `C:\temp\`.
2. **Create a Python environment**:
   \`\`\`
   conda create -n cluster python=3.11 pandas numpy scikit-learn matplotlib seaborn sqlalchemy psycopg2 python-dotenv jupyter -y
   conda activate cluster
   \`\`\`
3. **Set up the database** by running each SQL script in order in pgAdmin.
4. **Create a `.env` file** in the project root with `PG_PASSWORD=your_postgres_password`.
5. **Run the notebook**: `jupyter notebook notebooks/01_eda.ipynb`.
6. **Refresh the Tableau workbook** by pointing it at the exported `data/customer_segments.csv`.

## Dashboard Preview

Interactive version: **[Tableau Public →](https://public.tableau.com/views/CustomerSegmentation-OnlineRetailRFMK-Means/Dashboard1)**

The dashboard supports cross-filtering — clicking any segment bar filters the entire view to that segment's customers.

## Author

**Dillon Han** — [GitHub](https://github.com/handillon1)
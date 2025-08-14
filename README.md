# Intelligent Data Analysis Platform

An advanced, **AI-driven** platform for automated data analysis.  
It features a modular architecture that intelligently processes user queries for both **web-based data scraping** and **complex database analysis**.

The platform dynamically generates and executes Python code on the fly using a **Large Language Model (LLM)**.  
It includes a self-healing mechanism to debug and retry failed code executions, making it highly resilient for real-world tasks.

---

## 🚀 Features

- **Dual-Workflow Architecture** — Handles both web scraping and database analysis tasks.
- **Dynamic Code Generation** — Creates tailored Python scripts per query instead of relying on fixed logic.
- **Self-Healing Execution** — Detects errors, requests LLM-based fixes, and retries automatically.
- **Robust Web Scraping** — Uses Playwright with stealth mode for JavaScript-heavy sites.
- **Intelligent Data Cleaning** — LLM-powered numeric data detection and formatting.
- **Extensible & Modular** — Easy to add new workflows or integrations.

---

## 📂 Project Structure

reshavs project/
├── app/
│ ├── init.py
│ ├── main.py # FastAPI app entry point
│ └── api.py # Core API logic
├── core/
│ ├── init.py
│ ├── base.py # Workflow base classes
│ └── config.py # Config & LLM setup
├── workflows/
│ ├── init.py
│ ├── web_scraping.py # Web scraping workflow
│ └── database_analysis.py # Database workflow
├── utils/
│ ├── init.py
│ ├── constants.py # Project constants
│ ├── duckdb_utils.py # DuckDB helpers
│ └── prompts.py # LLM prompts
├── tests/
│ └── test_api.py # API tests
├── .env.example # Example env vars
├── .gitignore
├── requirements.txt # Python deps
└── README.md

yaml
Copy
Edit

---

## ⚙ How It Works

### 1. **Web Scraping Workflow** (`multi_step_web_scraping`)
Triggered when a query contains a **URL**.

1. **Fetch Data** — Playwright scrapes full HTML.
2. **Extract & Clean** — Main table → pandas DataFrame → cleaned.
3. **Save CSV** — Stored as `temp_web_data.csv`.
4. **Generate Python Script** — LLM writes a pandas script for analysis.
5. **Execute & Self-Fix** — Runs script, retries on failure.
6. **Return Result** — Outputs JSON.

---

### 2. **Database Analysis Workflow** (`database_analysis`)
Triggered when the query references a **database** (e.g., S3 path).

1. **Create Data Summary** — Extracts schema & details.
2. **Generate Python Script** — LLM writes a DuckDB script.
3. **Execute & Self-Fix** — Runs script, retries on failure.
4. **Return Result** — Outputs JSON.

---

## 🛠 Setup & Installation

### Prerequisites
- Python 3.10+
- Google Gemini API Key

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd "reshavs project"
2. Create a Virtual Environment
bash
Copy
Edit
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
3. Install Dependencies
bash
Copy
Edit
pip install -r requirements.txt
4. Configure Environment Variables
Rename .env.example → .env and set your key:

env
Copy
Edit
GEMINI_API_KEY="your_actual_gemini_api_key_here"
5. Install Playwright Browsers
bash
Copy
Edit
playwright install
▶ Running the Application
bash
Copy
Edit
uvicorn app.main:app --reload
API will be available at:
http://127.0.0.1:8000

📡 API Usage
Endpoint
bash
Copy
Edit
POST /api/
Form Data:

questions_txt → Path to .txt file containing your query.

Example — Web Scraping
File: wiki_films_question.txt

plaintext
Copy
Edit
Scrape the list of highest grossing films from Wikipedia...
URL: https://en.wikipedia.org/wiki/List_of_highest-grossing_films

1. How many $2 bn movies were released before 2000?
2. Which is the earliest film that grossed over $1.5 bn?
3. What's the correlation between Rank and Peak?
4. Draw a scatterplot of Rank and Peak with a red dotted regression line.
Run:

bash
Copy
Edit
curl -X POST "http://127.0.0.1:8000/api/" \
     -F "questions_txt=@wiki_films_question.txt"
Example — Database Analysis
File: high_court_question.txt

plaintext
Copy
Edit
The Indian high court judgement dataset is located at:
s3://indian-high-court-judgments/...

Q1. Which high court disposed the most cases from 2019 - 2022?
Q2. Regression slope of date_of_registration - decision_date by year for court=33_10?
Q3. Scatterplot of year vs. delay days with regression line.
Run:

bash
Copy
Edit
curl -X POST "http://127.0.0.1:8000/api/" \
     -F "questions_txt=@high_court_question.txt"
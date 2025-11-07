# Payslip XML Validator

This repository contains a Python-based validator for Payslip XML files. The validator ensures that XML files conform to the schema: `PayslipXML_v2.0_schema_NEW_07_2023.xsd`.

---

## Assumptions

- XML files are checked only for **schema compliance**.
- Validator does **not** check the semantic correctness or financial sanity of the data.
- Python 3.8+ is required.
- Required packages: `lxml`, `pytest`, `pytest-html`.

---

## How to Run

### Install dependencies

```bash
pip install -r requirements.txt
```

### Run tests
```bash
pytest --html=tests/report.html --self-contained-html
```

## Test Plan

**Objective:**  
Verifies XML files according to the schema. (can be configured in file: tests\conftest.py)

**Test Cases:**  
- Place valid XML files in `tests/data/valid`  
- Place invalid XML files in `tests/data/invalid`

**Validation:**  
- Logs messages for each validation step.  
- Invalid files trigger test failures.  
- For more detailed information about failures, check the generated `tests/report.html` file.


**Not Covered:**  
- Business logic errors or incorrect financial data.

## CI/CD
- When a commit is pushed to the repository GitHub Actions automatically runs the tests.  
- The generated test artifacts from GitHub Actions include the `report.html`, which can be downloaded for inspection.
- If you do not want to trigger actions, add [skip ci] to your commit message.

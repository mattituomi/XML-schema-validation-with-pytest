from pathlib import Path
import pytest



@pytest.fixture(scope="session")
def schema_path():
    # Corrected path based on your actual file
    return Path("tests/data/schema/PayslipXML_v2.0_schema_NEW_07_2023.xsd").resolve()

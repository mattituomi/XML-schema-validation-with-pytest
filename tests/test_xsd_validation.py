import pytest
from pathlib import Path
from validator import PayslipValidator, PayslipValidationError
import logging
log = logging.getLogger(__name__)
VALID_DIR = Path("tests/data/valid")
INVALID_DIR = Path("tests/data/invalid")

@pytest.mark.parametrize(
    "xml_file",
    sorted(VALID_DIR.glob("*.xml")),
    ids=lambda p: p.name  # ✅ use the filename as test name
)
def test_all_valid(xml_file, schema_path):
    PayslipValidator(xml_file, schema_path).run()

@pytest.mark.parametrize(
    "xml_file",
    sorted(INVALID_DIR.glob("*.xml")),
    ids=lambda p: p.name  # ✅ use the filename as test name
)
def test_all_invalid(xml_file, schema_path):
    log.info(f"Testing invalid file: {xml_file}")
    PayslipValidator(xml_file, schema_path).run()

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
    #with pytest.raises(PayslipValidationError) as excinfo:
    #    PayslipValidator(xml_file, schema_path).run()

    ## Ensure at least one error message contains element/attribute hint
    #val_err: PayslipValidationError = excinfo.value
    #assert val_err.errors, "No detailed errors captured"
    ## optional: assert any message mentions angle bracket or element name pattern
    #join = " ".join(msg for _, msg in val_err.errors)
    #assert any(tag in join for tag in ["Element", "attribute", "<", "amount", "EmployeeID", "Salary"]), (
    #    f"No identifiable path or element in error messages for {xml_file.name}:\n{join}"
    #)

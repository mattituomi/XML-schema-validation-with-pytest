from pathlib import Path
from lxml import etree
from typing import List, Optional
import logging
log = logging.getLogger(__name__)

class PayslipValidationError(Exception):
    """Raised for fatal validation failures. This method can be modified to include more context and better error messages."""
    def __init__(self, message: str, file: Path, line: Optional[int] = None, errors: Optional[List]=None):
        self.file = file
        self.line = line
        self.errors = errors or []
        super().__init__(f"[{file.name}] {message} (line {line if line else '?'})")


class PayslipValidator:
    def __init__(self, xml_path, xsd_path, *, base_dir: Path | None = None):
        """
        xml_path, xsd_path: Path-like or str
        base_dir: optional Path to resolve relative paths against.
                  Defaults to Path.cwd() (current working directory).
                  To resolve relative to this file: set base_dir=Path(__file__).parent
        """
        self.base_dir = Path(base_dir) if base_dir is not None else Path.cwd()
        self.xml_path = self._normalize_path(xml_path)
        self.xsd_path = self._normalize_path(xsd_path)
        self.first_line: str = ""
        self.rest: bytes = b""
        self.schema: Optional[etree.XMLSchema] = None
        self.warnings: List[str] = []

    def _normalize_path(self, p) -> Path:
        """
        Normalize a path or path-like:
          - expanduser (~)
          - if absolute -> return resolved path (strict=False)
          - if relative -> resolve against self.base_dir
        """
        pth = Path(p)
        # Expand user immediately
        pth = pth.expanduser()

        if pth.is_absolute():
            # resolve but don't require existence (strict=False)
            return pth.resolve(strict=False)
        # relative -> resolve against base_dir
        return (self.base_dir / pth).resolve(strict=False)

    # ---------- helpers ----------
    def _raise_if_missing(self, path: Path, message: str):
        if not path.exists():
            raise PayslipValidationError(message + f": resolved path {path}", path)


    # ---------- steps ----------
    def load_schema(self) -> None:
        self._raise_if_missing(self.xsd_path, "XSD schema not found. You can set it within pytest schema_path fixture.")
        schema_doc = etree.parse(str(self.xsd_path))
        self.schema = etree.XMLSchema(schema_doc)

    def read_file(self) -> None:
        self._raise_if_missing(self.xml_path, "XML file not found")
        with open(self.xml_path, "rb") as f:
            # read first line as text (best-effort) and rest as bytes
            self.first_line = f.readline().decode(errors="ignore")
            self.rest = f.read()

    def check_declaration(self) -> None:
        """
        Verify that the XML declaration specifies ISO-8859-15 encoding. It is assumed that it is within the first line.
        """
        # Must explicitly declare ISO-8859-15
        if 'encoding="ISO-8859-15"' not in self.first_line:
            raise PayslipValidationError(f"XML declaration must specify encoding='ISO-8859-15'. First line was: '{self.first_line}'", self.xml_path, 1)


    def check_encoding(self) -> None:
        """
        Verify that the file can actually be decoded as ISO-8859-15.
        If decoding fails, raise PayslipValidationError.
        """
        try:
            # Try decoding the rest of the file bytes
            _ = self.rest.decode("iso-8859-15")
        except UnicodeDecodeError as e:
            raise PayslipValidationError(
                f"File content is not valid ISO-8859-15: {e}",
                self.xml_path,
            )

        # If decode succeeded, optionally confirm declaration consistency
        if 'encoding="ISO-8859-15"' not in self.first_line:
            raise PayslipValidationError(
                "XML declaration must specify encoding='ISO-8859-15'",
                self.xml_path,
                1
            )


    def validate_schema(self) -> None:
        if self.schema is None:
            raise PayslipValidationError("Schema not loaded", self.xsd_path)

        # create fresh parser for isolation
        parser = etree.XMLParser(schema=self.schema)

        try:
            etree.fromstring(self.first_line.encode("ISO-8859-15") + self.rest, parser)
            return  # valid
        except etree.XMLSyntaxError as e:
            # Build a plain list of (line, message) for each error_log entry
            log_entries = []
            primary_msg=f"{e}"
            primary_line = None

            # raise with plain data only; suppress original traceback to keep output clean
            raise PayslipValidationError(
                f"Schema validation failed: {primary_msg}",
                self.xml_path,
                primary_line,
                errors=log_entries
            ) from None



    # ---------- runner ----------
    def run(self) -> None:
        """Run all validation steps. Raises PayslipValidationError on fatal failures."""
        log.info(f"Validating {self.xml_path.name}")
        self.load_schema()
        log.info("reading file")
        self.read_file()
        log.info("checking declaration")
        self.check_declaration()
        log.info("checking encoding")
        self.check_encoding()
        log.info("validating schema")
        self.validate_schema()
        log.info(f"Finished validating {self.xml_path.name}")

if __name__ == "__main__":
    base = Path(__file__).parent.parent 
    PayslipValidator(
        xml_path = base / "tests" / "data" / "valid" / "PayslipXML_v2.0_example_1.xml",
        xsd_path = base / "tests" / "data" / "schema" / "PayslipXML_v2.0_schema_NEW_07_2023.xsd",
        base_dir = base
    ).run()

    error_case=PayslipValidator(
        xml_path = base / "tests" / "data" / "invalid" / "InvalidDate.xml",
        xsd_path = base / "tests" / "data" / "schema" / "PayslipXML_v2.0_schema_NEW_07_2023.xsd",
        base_dir = base
    ).run()

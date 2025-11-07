from pathlib import Path

def reencode_all_xmls(folder: str | Path, source_encoding: str = "utf-8", target_encoding: str = "iso-8859-15") -> None:
    """
    Re-encodes all .xml files under a folder to ISO-8859-15 and ensures
    their XML declaration matches the new encoding.

    Args:
        folder: Directory containing XML files (recursively processed)
        source_encoding: Original encoding (default 'utf-8')
        target_encoding: New encoding (default 'iso-8859-15')
    """
    folder = Path(folder)
    if not folder.exists():
        raise FileNotFoundError(f"Folder not found: {folder}")

    xml_files = list(folder.rglob("*.xml"))
    if not xml_files:
        print(f"No XML files found in {folder}")
        return

    print(f"🔍 Found {len(xml_files)} XML files in {folder}")
    for file in xml_files:
        try:
            text = file.read_text(encoding=source_encoding)
        except UnicodeDecodeError:
            print(f"⚠️  Skipping {file.name}: cannot decode as {source_encoding}")
            continue

        # Normalize line endings and fix first line
        lines = text.splitlines()
        if lines and lines[0].startswith("<?xml"):
            # Replace encoding declaration if it exists
            import re
            lines[0] = re.sub(
                r'encoding="[^"]+"',
                f'encoding="{target_encoding.upper()}"',
                lines[0],
            )
        else:
            # Insert declaration if missing
            lines.insert(0, f'<?xml version="1.0" encoding="{target_encoding.upper()}"?>')

        text_fixed = "\n".join(lines)

        # Write with target encoding
        file.write_text(text_fixed, encoding=target_encoding)
        print(f"✅ Re-encoded {file.name} → {target_encoding.upper()}")

    print("\n🎉 All XML files re-encoded successfully.")


if __name__ == "__main__":
    # Example usage:
    # reencode_all_xmls("tests/data")
    # or full path:
    reencode_all_xmls(r"C:\PythonProjects\XML-schema-validation-with-pytest\tests\data")

# vCard QR Generator

A simple Python utility that generates a vCard QR code (`contact_qr.png`) based on contact details provided in a `.env` file.

This project relies on the [Segno](https://github.com/heuer/segno) library to generate QR codes with embedded vCard information.

## Prerequisites

- Python 3.13+
- [uv](https://github.com/astral-sh/uv) (recommended) or pip

## Setup

1. **Clone the repository** (if you haven't already):

   ```bash
   git clone <repository_url>
   cd vcard
   ```

2. **Install dependencies**:

   Using `uv`:

   ```bash
   uv sync
   ```

   Using standard `pip`:

   ```bash
   pip install -r requirements.txt
   # Or install manually:
   # pip install segno python-dotenv
   ```

3. **Configure Environment Variables**:
   Create a `.env` file in the root directory and populate it with your contact details. See the [Configuration](#configuration) section below.

## Usage

Run the script to generate your QR code:

Using `uv`:

```bash
uv run main.py
```

Using Python directly:

```bash
python main.py
```

The script will generate a file named `contact_qr.png` in the current directory containing your vCard QR code.

## Configuration

Add the following variables to your `.env` file.

```dotenv
# REQUIRED (At least one name field is needed)
CONTACT_DISPLAY_NAME=""
CONTACT_SURNAME=""
CONTACT_GIVEN_NAME=""

# OPTIONAL (Leave blank to exclude)
CONTACT_PHONE=""
CONTACT_EMAIL=""
CONTACT_URL=""
CONTACT_ORG=""
CONTACT_TITLE=""
CONTACT_STREET=""
CONTACT_CITY=""
CONTACT_COUNTRY=""
CONTACT_BIRTHDAY=""
```

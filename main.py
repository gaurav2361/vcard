import os
import segno
from segno import helpers
from dotenv import load_dotenv

# 1. Load environment variables from the .env file
load_dotenv()

def create_dynamic_vcard():
    # 2. Map .env variables to segno parameters
    # We create a dictionary of all possible fields
    vcard_data = {
        'name': f"{os.getenv('CONTACT_SURNAME')};{os.getenv('CONTACT_GIVEN_NAME')}",
        'displayname': os.getenv('CONTACT_DISPLAY_NAME'),
        'email': os.getenv('CONTACT_EMAIL'),
        'phone': os.getenv('CONTACT_PHONE'),
        'url': os.getenv('CONTACT_URL'),

        # New Optional Details
        'org': os.getenv('CONTACT_ORG'),       # Organization / Company
        'title': os.getenv('CONTACT_TITLE'),   # Job Title
        'street': os.getenv('CONTACT_STREET'), # Street Address
        'city': os.getenv('CONTACT_CITY'),     # City
        'country': os.getenv('CONTACT_COUNTRY'), # Country
        'birthday': os.getenv('CONTACT_BIRTHDAY'), # BDAY (YYYY-MM-DD)
    }

    # 3. Clean the data: Remove keys where the value is None or empty string
    # This ensures that empty env vars don't create empty fields in the vCard
    clean_data = {k: v for k, v in vcard_data.items() if v}

    print("Generating QR for:", clean_data.get('displayname', 'Unknown'))

    # 4. Generate the QR code using the vCard helper
    # **clean_data unpacks the dictionary into arguments
    qr = helpers.make_vcard(**clean_data)

    # 5. Save the file
    qr.save("contact_qr.png", scale=10, dark="black", light="white")
    print("Saved to contact_qr.png")

if __name__ == "__main__":
    create_dynamic_vcard()

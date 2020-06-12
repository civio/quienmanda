Entities and relations among them can be created automatically by uploading Facts via a CSV file. The file to import must:

 * Have a title row. The values of the fields in this row will be used as column names.
 * Contain at least three columns: 'source', 'role' and 'target'. Additional columns will be imported as additional attributes of the Fact.
 * If attributes 'from', 'to' or 'at' exist, they will be added as date attributes in the new relation.
 * The 'via' attribute is special too: it will be shown as the source of the information when displaying the relation.

NOTE: If generating the CSV file from Excel, be careful with the character encoding. The application will try to guess the encoding of the uploaded file (using Charlock Holmes), but it may not always guess right and misread some accented characters. If you don't know how to set the encoding manually to UTF8 (using for example TextMate), try at least to save in Excel as "Windows Comma Separated Values", it seems to make detection by Charlock Holmes more accurate.

The process has two steps: the upload will create a number of Fact objects, containing all the source data. Once the data is in the database, Facts are 'processed' to match them against existing entities (or new ones that will be created if needed).

Steps are as follows:

1. Go to the Import page vía the Admin panel, and select the CSV file to import.
1. Clicking 'Upload' will parse the CSV file and create a Fact in the database for each row in the source file. The uploader checks a Fact does not already exist before creating (using source-role-target as the key), so uploading one file again and again is safe, i.e. the uploading is idempotent. (Note: existing Facts are not modified, so changes in fields outside the primary key will be ignored.)
1. After a successful upload, a results summary page will be shown, listing the uploaded facts, and showing which ones were already known and were thus ignored.
1. Once the file is uploaded, facts need to be processed: this can be done either from the main Import page, or from the upload results page. New entities and relations are created at this point (after the dry run results are reviewed and approved by the user).

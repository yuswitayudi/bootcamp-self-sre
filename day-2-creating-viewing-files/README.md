# Day 2: Linux Command Line - Working with Files (Creation & Viewing)

**Date:** May 12, 2025

**Topics Covered:**

* **File Creation (Empty):**
    * `touch <filename>`: Creates an empty file or updates the timestamp of an existing file.
    * `touch <file1> <file2> ...`: Creates multiple empty files.
* **Viewing File Content:**
    * `cat <filename>`: Displays the entire content of a file.
    * `less <filename>`: Displays file content page by page, allowing navigation.
    * `head <filename>`: Displays the first 10 lines of a file.
    * `head -n <number> <filename>`: Displays the first `<number>` lines.
    * `tail <filename>`: Displays the last 10 lines of a file.
    * `tail -n <number> <filename>`: Displays the last `<number>` lines.
    * `tail -f <filename>`: Follows the file in real-time, showing new lines as they are added.
* **Creating Files with Content (via Redirection):**
    * `echo "<text>" > <filename>`: Writes the `<text>` into `<filename>`, overwriting any existing content.
    * `echo "<text>" >> <filename>`: Appends the `<text>` to the end of `<filename>`.

**Key Takeaways:**

* `touch` is a quick way to create empty files.
* `cat` is suitable for viewing short files.
* `less` is essential for navigating long files.
* `head` and `tail` are useful for inspecting the beginning and end of files, especially logs.
* `tail -f` is invaluable for real-time monitoring of file updates.
* Redirection (`>` and `>>`) provides a basic way to add content to files from the command line.

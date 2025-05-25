# Day 3: Linux Command Line - `grep` & Basic Redirection Refresher

**Date:** May 26, 2025

**Topics Covered & Commands Practiced:**

* **`grep` Command (Review with practical application):** Filters lines matching a specific pattern.

    * **Basic Search:** Find all lines containing "ERROR".
        ```bash
        grep "ERROR" app_events.log
        ```
    * **Case-Insensitive Search (`-i`):** Find "warning" or "WARNING".
        ```bash
        grep -i "warning" app_events.log
        ```
    * **Invert Match (`-v`):** Show lines that *do not* contain "INFO".
        ```bash
        grep -v "INFO" app_events.log
        ```
    * **Count Matches (`-c`):** Count the number of "ERROR" messages.
        ```bash
        grep -c "ERROR" app_events.log
        ```
    * **Bonus: Extended Regex (`-E`) for OR condition and Pipes (`|`):** Count lines with "ERROR" or "WARNING".
        ```bash
        grep -E "ERROR|WARNING" app_events.log | wc -l
        ```

* **I/O Redirection (Review & Practical Use):** Controlling where command output goes.

    * **Overwrite (`>`):** Extract "ERROR" lines and save to `errors.log` (overwrites if exists).
        ```bash
        grep "ERROR" app_events.log > errors.log
        cat errors.log # Verify content
        ```
    * **Append (`>>`):** Append "WARNING" lines to `errors.log`.
        ```bash
        grep "WARNING" app_events.log >> errors.log
        cat errors.log # Verify updated content
        ```

**Key Takeaways & Practice Highlights:**

* Re-enforced the power of **`grep`** for efficient log analysis, especially with common options (`-i`, `-v`, `-c`, `-E`).
* Solidified understanding of **`>`** for creating/overwriting files and **`>>`** for adding to them. This is crucial for saving filtered data or building simple log files.
* Practiced using **pipes (`|`)** to chain `grep` output to `wc -l` for more complex filtering and counting.
* These commands are fundamental building blocks for more advanced scripting and troubleshooting in SRE and Cloud Engineering.


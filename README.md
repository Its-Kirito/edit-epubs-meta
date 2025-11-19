# 📚 edit_epubs_meta

### A simple Zsh tool for bulk editing EPUB metadata and filenames

*Version 1.0 — by Edward (Kirito)*

---

## 📖 Overview

`edit_epubs_meta` is a lightweight Zsh script designed to make **bulk metadata editing** and **clean renaming** of EPUB files fast and painless.

It was originally built to help organize **light novel collections** (especially for **Kavita** libraries), where each volume belongs to a series and should have:

* consistent filenames
* consistent titles
* correct series metadata
* correct series indices

Instead of manually editing EPUBs one-by-one, this script automates the repetitive parts.

---

## 🛠 Requirements

* **Zsh** (script uses Zsh features like `$match`)
* **Calibre** installed 
  (script uses Calbre features like `ebook-meta`)

Check with:

```sh
ebook-meta --version

# if you don't have calibre
sudo apt install calibre
```

---

## ▶️ Usage

Allow execution and then Run the script inside a folder containing EPUBs:

```sh
# Enable script execution
chmod u+x path_to_script/edit_epubs_meta

# Run the script
./edit_epubs_meta 

# or
path_to_script/edit_epubs_meta
```

You will see a menu:

```
Currently working in:
/path/to/your/lightnovels/SeriesName/

1. List metadata
2. Bulk edit metadata
3. Bulk rename filenames
4. Exit script
```

Tip:
Create an alias (in ~/.zshrc) to the script to avoid typing a lot
```sh
alias epubmeta="/full/path/to/edit_epubs_meta"
```

After that you can simply run
```sh
epubmeta
```

---

## ✨ Features (v1.0)

✔️ Bulk edit **Title** and **Title-Sort** using a base title\
✔️ Bulk edit **Series** name and auto-assign **Series Index**\
✔️ Bulk rename EPUB filenames using volume numbers\
✔️ Displays useful metadata for inspection\
✔️ Simple CLI menus\
✔️ Built around **Kavita-recommended organization**

---


## 🔧 Feature Details

### 1️⃣ Bulk Rename Filenames

Enter a base filename, and the script renames all EPUBs to:

```
BaseTitle — <number>.epub
```

Examples:

| Old Filename            | New Filename         |
| ----------------------- | -------------------- |
| `book 1.epub`           | `My Series — 1.epub` |
| `Vol_02 Something.epub` | `My Series — 2.epub` |
| `LN-003.epub`           | `My Series — 3.epub` |

---

### 2️⃣ Bulk Edit Titles

Extracts number from filename and sets:

* **Title**
* **Title Sort**

Example output:

```
Original:
Title: Random Book 01

Updated:
Title: My Light Novel — 1
Title Sort: My Light Novel — 1
```

---

### 3️⃣ Bulk Edit Series

Sets:

* Series name (same for all books)
* Series index (from filename number)

Useful for Kavita, since it needs correct ordering to display volumes properly.

**Recommended:**
Rename files first → run this.

---

## 📌 IMPORTANT: Number Extraction Requirement

For both renaming and metadata indexing, the script extracts a **volume number** from each filename.

Examples of acceptable filenames:

```
Book 1.epub
Volume_02 - Title.epub
LN-title-v3.epub
RandomName 47 test.epub
```

The number can appear *anywhere* in the filename.
The script will detect it automatically.

### ❌ Files without numbers will be skipped:

```
MyCoolBook.epub   → skipped (no numbers found)
```

### ✔ Recommended workflow:

1. **Rename files cleanly first**, using the script
2. Then run:

   * Bulk Edit Titles
   * Bulk Edit Series + Index

This ensures consistent ordering and clean metadata.

---

## 📂 Folder Structure Assumption (Kavita-Friendly)

This tool assumes:

* Each series (e.g., Book Series A) has its **own folder**
* All EPUBs for that series are inside that folder
* You run the script *inside that folder*

Example:

```
/Light Novels/
    /Mushoku Tensei/
        01.epub
        02.epub
        03.epub
    /Re:Zero/
        vol 1.epub
        vol 2.epub
```

The script prints the **current path** in the main menu so you always know where you're operating.

---

## 🚧 Project Notes

This is an early version (v1) made for personal use, but offers enough functionality to be useful for anyone maintaining a library of novels, light novels, or anything requiring ordered metadata.

More features are planned, including:

* Auto-fixing inconsistent numbers
* Multi-extension support (CBZ, PDF, etc.)
* Richer more robust bulk editing features

---

## 🤝 Contributions

Suggestions, feature ideas, and PRs are welcome!
Feel free to open an issue on GitHub.

---

## 💬 Final Thoughts

This tool was created simply because **manually editing dozens of EPUBs sucks**, and Calibre doesn’t offer good bulk operations for series titles and indices.

If you’re organizing a digital library — especially with **Kavita** — this script will save you time and headaches.

Enjoy your clean, consistent EPUB metadata! 🚀📚

---
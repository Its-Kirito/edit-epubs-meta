#!/usr/bin/zsh
# --------------------------------------
# Name: edit_epubs_meta
# Description: Bulk metadata editing and renaming for EPUB files.
# Author: Edward (Kirito)
# Version: 1.1
# --------------------------------------


# --------------------------------------
# Helper Method: Print a visual line separator for output formatting.
# --------------------------------------
function print_separator() {
    echo "----------------------------------------"
}

# --------------------------------------
# Prints useful metadata fields for a given list of EPUB files.
# @param $@ - List of EPUB files
# --------------------------------------
function print_useful_metadata() {
    for file in "$@"; do
        echo
        print_separator
        echo "Metadata for: $file"
        print_separator

        ebook-meta "$file" | grep -iE "Author|Title|Title sort|Series|index"
        echo
    done
}

# --------------------------------------
# Updates the Series name and Series Index for EPUB files.
# Uses numbers found in filename to determine the index.
# @param $1  — New Series name
# @param $@ - List of EPUB files (after shift)
# --------------------------------------
function bulk_change_series_name() {
    local new_series_name="$1"
    local series_num

    shift

    for file in "$@"; do
        echo
        print_separator
        echo "Book: $file"
        print_separator

        echo "Original:"
        ebook-meta "$file" | grep -i "series"

        # Update series name
        ebook-meta "$file" --series "$new_series_name" >/dev/null

        # Extract number from filename → series index
        if [[ $file =~ ([0-9]+) ]]; then
            series_num="${match[1]}"
            ebook-meta "$file" --index "$series_num" >/dev/null
        else
            echo
            echo "⚠ Unable to update series index (no number found in filename)"
        fi

        echo
        echo "Updated:"
        ebook-meta "$file" | grep -i "series"
        echo
    done
}

# --------------------------------------
# Updates Title and Title Sort metadata for EPUB files.
# Uses number in filename to generate a series-consistent title.
# @param $1  — New base Title
# @param $@ - EPUB file list (after shift)
# --------------------------------------
function bulk_change_title() {
    local new_title="$1"
    local book_num

    shift

    for file in "$@"; do
        if [[ $file =~ ([0-9]+) ]]; then
            book_num="${match[1]}"

            echo
            print_separator
            echo "Book: $file"
            print_separator

            echo "Original:"
            ebook-meta "$file" | grep -i "title"

            # Apply new metadata
            ebook-meta "$file" --title       "$new_title — $book_num" >/dev/null
            ebook-meta "$file" --title-sort  "$new_title — $book_num" >/dev/null

            echo
            echo "Updated:"
            ebook-meta "$file" | grep -i "title"
            echo

        else
            echo
            echo "⚠ Unable to update: $file (no number found in filename)"
            echo
        fi
    done
}

# --------------------------------------
# Updates Author(s) metadata for EPUB files.
# 
# @param $1  — Name of Author(s)
# @param $@ - EPUB file list (after shift)
# --------------------------------------
function bulk_change_author() {
    local new_names="$1"

    # Left-shift parameters
    shift 

    for file in "$@"; do
        echo
        print_separator
        echo "Book: $file"
        print_separator

        echo "Original:"
        ebook-meta "$file" | grep -i "author"

        # Update author names
        ebook-meta "$file" -a "$new_names" >/dev/null

        echo
        echo "Updated:"
        ebook-meta "$file" | grep -i "author"
        echo
    done
}

# --------------------------------------
# Displays the main menu and prompts for user input.
# @param $1 — Optional: flag indicating previous invalid input (1 = invalid)
# --------------------------------------
function main_menu_prompt() {
    local choice
    clear >&2

    # If an invalid option was passed previously
    if [[ $1 -eq 1 ]]; then
        echo "!! X !! Unknown command. Please enter a valid choice (1 - 4)." >&2
        echo >&2
    fi

    echo "Currently working in:" >&2
    pwd >&2
    echo >&2

    echo "Select one of the following options:" >&2
    echo "  1. List files meta-data" >&2
    echo "  2. Bulk edit metadata" >&2
    echo "  3. Bulk rename filenames" >&2
    echo "  4. Exit script" >&2
    echo >&2

    echo -n "Enter your choice [1–4]: " >&2
    read -r choice

    echo $choice
}

# --------------------------------------
# Displays the submenu for bulk metadata editing options.
# --------------------------------------
function bulk_edit_menu_prompt() {
    local choice
    clear >&2

    echo "Bulk Editing Options:" >&2
    print_separator >&2
    echo "  1. Bulk edit Titles + Title Sort" >&2
    echo "  2. Bulk edit Series + Index" >&2
    echo "  3. Bulk edit Author(s)" >&2
    echo "  4. Return to main menu" >&2
    echo >&2

    echo -n "Enter your choice [1-3]: " >&2
    read -r choice

    echo $choice
}

# --------------------------------------
# Wait for the user to press Enter before continuing.
# --------------------------------------
function pause_till_user_interrupts() {
    echo
    echo -n "Press [Enter] to continue..."
    read -r _
}

# --------------------------------------
# Bulk rename files in directory using a base title and appending volume numbers
# Volume numbers are obtained from filenames
# @param $1 - New base title (filename prefix)
# @param $@ - EPUB file list (after shift)
# --------------------------------------
function bulk_file_rename() {
    local new_title="$1"
    local book_num new_file

    shift

    for file in "$@"; do
        if [[ $file =~ ([0-9]+) ]]; then
            book_num="${match[1]}"

            echo
            print_separator
            echo "Renaming: $file"
            print_separator

            echo "Original filename:"
            echo "$file"

            # Build new filename
            new_file="${new_title} — ${book_num}.epub"

            mv -- "$file" "$new_file"

            echo
            echo "Updated filename:"
            echo "$new_file"
            echo

        else
            echo
            echo "⚠ Unable to rename: $file (no number found in filename)"
            echo
        fi
    done
}

# --------------------------------------
# MAIN SCRIPT LOOP
# --------------------------------------
choice=$(main_menu_prompt)

until [[ "$choice" == "4" ]]; do
    invalid_input=0 # Flag for user input
    files=(*.epub)  # Get all .epub files in directory

    case "$choice" in
        1)
            print_useful_metadata "${files[@]}"
            pause_till_user_interrupts
            ;;

        2)
            while true; do
                choice=$(bulk_edit_menu_prompt)

                case "$choice" in
                    1)
                        echo -n "Enter new generic title: "
                        read -r title
                        bulk_change_title "$title" "${files[@]}"
                        pause_till_user_interrupts
                        ;;

                    2)
                        echo -n "Enter new series name: "
                        read -r series
                        bulk_change_series_name "$series" "${files[@]}"
                        pause_till_user_interrupts
                        ;;

                    3)
                        echo
                        echo "Enter author name in order: FirstName LastName."
                        echo "If Entering multiple authors, please separate each author using '&'.\nEg: Dave Joe & Bob Marley\n"
                        
                        echo -n "Enter name(s) of Author(s): "
                        read -r author_names
                        bulk_change_author "$author_names" "${files[@]}"

                        pause_till_user_interrupts
                        ;;

                    4)
                        break
                        ;;

                    *)
                        echo "Invalid choice. Please choose 1 - 3."
                        ;;
                esac
            done
            ;;

        3)
            echo -n "Enter new generic filename: "
            read -r filename
            bulk_file_rename "$filename" "${files[@]}"
            pause_till_user_interrupts
            ;;

        4)
            echo "Program will terminate."
            break
            ;;

        *)
            invalid_input=1
            ;;
    esac

    choice=$(main_menu_prompt $invalid_input)

done

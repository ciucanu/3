#!/bin/bash

# Function to get password using eva.sh script
get_password() {
    EVA_PATH="$1"
    password=$(./eva.sh "$EVA_PATH" -s)
    echo "$password"
}

# Function to execute SQL files
execute_sql() {
    SQL_FILE="$1"
    PG_CONNECTION="$2"
    PASSWORD="$3"
    psql "$PG_CONNECTION" -c "\\i $SQL_FILE" <<<"$PASSWORD"
}

# Main function
main() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: $0 [-a | -f <sql_file>]"
        exit 1
    fi

    # Parse command-line options
    while getopts ":af:" opt; do
        case $opt in
            a)  # Run all SQL files
                while IFS= read -r line; do
                    IFS=' ' read -r -a array <<< "$line"
                    SQL_FILE="${array[0]}"
                    PG_CONNECTION="${array[1]}"
                    EVA_PATH="${array[2]}"
                    PASSWORD=$(get_password "$EVA_PATH")
                    execute_sql "$SQL_FILE" "$PG_CONNECTION" "$PASSWORD"
                done < config.txt
                ;;
            f)  # Run a specific SQL file
                SQL_FILE="$OPTARG"
                if ! grep -q "^$SQL_FILE " config.txt; then
                    echo "Specified SQL file not found in config.txt"
                    exit 1
                fi
                LINE=$(grep "^$SQL_FILE " config.txt)
                IFS=' ' read -r -a array <<< "$LINE"
                PG_CONNECTION="${array[1]}"
                EVA_PATH="${array[2]}"
                PASSWORD=$(get_password "$EVA_PATH")
                execute_sql "$SQL_FILE" "$PG_CONNECTION" "$PASSWORD"
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done
}

# Run the main function with passed arguments
main "$@"




query1.sql postgres://username:password@localhost:5432/database /path/to/eva1.sh
query2.sql postgres://username:password@localhost:5432/database /path/to/eva2.sh


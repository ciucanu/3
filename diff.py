#!/usr/bin/env python3
import argparse
import yaml

def compare_gitlab_ci_files(file1, file2):
    """Compares two .gitlab-ci.yml files and prints differences in a git diff-like format.

    Args:
        file1 (str): Path to the first file.
        file2 (str): Path to the second file.
    """

    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        data1 = yaml.safe_load(f1)
        data2 = yaml.safe_load(f2)

    all_keys = set(data1.keys()) | set(data2.keys())

    for key in all_keys:
        if key not in data1:
            print(f"diff --git a/{file1} b/{file2}")
            print(f"index 0000000..0000000 100644")
            print(f"--- a/{file1}")
            print(f"+++ b/{file2}")
            print(f"-{key}: ")  # Removed in file1
            print(f"+{key}: {data2[key]}")
        elif key not in data2:
            print(f"diff --git a/{file1} b/{file2}")
            print(f"index 0000000..0000000 100644")
            print(f"--- a/{file1}")
            print(f"+++ b/{file2}")
            print(f"-{key}: {data1[key]}")  # Removed in file2
            print(f"+{key}: ")
        elif data1[key] != data2[key]:
            print(f"diff --git a/{file1} b/{file2}")
            print(f"index 0000000..0000000 100644")
            print(f"--- a/{file1}")
            print(f"+++ b/{file2}")
            print(f"-{key}: {data1[key]}")
            print(f"+{key}: {data2[key]}")

        print("\n")  # Add empty line between changes

def main():
    parser = argparse.ArgumentParser(description="Compare .gitlab-ci.yml files")
    parser.add_argument("file1", help="Path to the first .gitlab-ci.yml file")
    parser.add_argument("file2", help="Path to the second .gitlab-ci.yml file")
    args = parser.parse_args()

    compare_gitlab_ci_files(args.file1, args.file2)


if __name__ == "__main__":
    main()

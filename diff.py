import argparse
import yaml

def compare_gitlab_ci_files(file1, file2):
    """Compares two .gitlab-ci.yml files and prints the differences.

    Args:
        file1 (str): Path to the first file.
        file2 (str): Path to the second file.
    """

    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        data1 = yaml.safe_load(f1)
        data2 = yaml.safe_load(f2)

    # Get unique keys from both files
    all_keys = set(data1.keys()) | set(data2.keys())

    for key in all_keys:
        if key not in data1:
            print(f"- Key '{key}' missing in {file1}")
        elif key not in data2:
            print(f"- Key '{key}' missing in {file2}")
        elif data1[key] != data2[key]:
            print(f"- Values differ for key '{key}':")
            print(f"  - {file1}: {data1[key]}")
            print(f"  - {file2}: {data2[key]}")

def main():
    parser = argparse.ArgumentParser(description="Compare .gitlab-ci.yml files")
    parser.add_argument("file1", help="Path to the first .gitlab-ci.yml file")
    parser.add_argument("file2", help="Path to the second .gitlab-ci.yml file")
    args = parser.parse_args()

    compare_gitlab_ci_files(args.file1, args.file2)


if __name__ == "__main__":
    main()

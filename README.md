
# Name Lookup Tool

This repository contains three main scripts to help you check the availability of GitHub usernames and get the popularity score for names:

1. **GitHub Username Availability Checker** (`check_github_usernames.sh`) - Bash script to check if a username is available on GitHub.
2. **Popularity Score Checker** (`check_popularity_score.js`) - Node.js script that uses Puppeteer to scrape search results for name popularity.
3. **Main Script** (`name_lookup.sh`) - Orchestrates the GitHub and Popularity Score checks.

## 🛠️ How It Works

1. **GitHub Availability Check**: The script first checks GitHub to see if the provided names are available.
2. **Popularity Score Check (Optional)**: After the GitHub check, the user is asked if they want to check the popularity scores for the names that were found to be available.

## 📋 Prerequisites

### If Using the Bash GitHub Username Lookup Only:
- **No Node.js required**.
- Ensure you have **curl** installed:
  ```bash
  curl --version
  ```

### If Using the Full Popularity Score Lookup:
- **Node.js** and **npm** are required.
- Install [Node.js](https://nodejs.org/) (if not already installed).
- Install **Puppeteer** by running:
  ```bash
  npm install puppeteer
  ```

## 📦 Installation

1. **Download the Scripts** and unzip the package.
2. **Make All Scripts Executable**:
   ```bash
   chmod +x check_github_usernames.sh
   chmod +x name_lookup.sh
   ```

### For Popularity Score Lookup (Full Solution):
1. **Install Node.js Dependencies**:
   ```bash
   npm install puppeteer
   ```

## 🛠️ Usage

1. **Run the Main Script**:
   ```bash
   ./name_lookup.sh
   ```

2. **Follow the Prompts**:
   - Enter the names to check (space-separated or newline-separated).
   - The script will first check **GitHub availability**.
   - After the GitHub check, you will be prompted:
     ```bash
     Do you want to check popularity scores for the available names? (y/n):
     ```
   - Type `y` to proceed with the **popularity score check** or `n` to **skip** it.

## 📖 Example Input:
```
SyncPanther
TruthSync
Obliviation
SyncForge
```

## 📖 Example Output:
```
Running GitHub availability check for the provided names...
✅ Available: SyncPanther
❌ Taken: TruthSync
✅ Available: SyncForge

Do you want to check popularity scores for the available names? (y/n): y

📈 Popularity Score for 'SyncPanther': 25/100
📈 Popularity Score for 'SyncForge': 30/100
```

## 📝 Caching

- The **GitHub availability** and **popularity score** lookups are cached in separate files (`github_lookup_cache.txt` and `popularity_lookup_cache.txt`).
- This ensures that repeated lookups do not fetch the same data multiple times.

## 🛡️ License

This project is open-source and available under the **MIT License**.

## 📬 Contact

If you have any questions or feedback, feel free to reach out:

- **GitHub**: [YourUsername](https://github.com/YourUsername)

# AGENT Instructions

## Mission
- Assist in completing missing applications, website files and configurations for this multi-domain webserver.
- Take initiative to propose or implement changes that get the webserver fully operational.

## Testing
- When Python files are modified, run:
  ```
  python3 -m py_compile $(git ls-files '*.py')
  ```
- When shell scripts are modified, run:
  ```
  shellcheck $(git ls-files '*.sh')
  ```
- Report the results of these checks in the PR summary.

## Style
- Keep commit messages brief but descriptive.
- Prefer small, focused commits when possible.

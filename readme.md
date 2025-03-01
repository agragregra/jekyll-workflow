# Jekyll Workflow

Ready-to-use workflow for quickly starting with Jekyll. It includes configurations for development, local network access, build, and deployment of the project.

```
git clone https://github.com/agragregra/jw .; rm -rf trunk readme.md .git
```

## Features

- **Workflow**: Jekyll rebuilds the project in real-time and provides local network access like ```http://192.168.1.126:4000```.
- **Optimized configurations**: Separate configurations for development (`_config_dev.yml`) and production (`_config.yml`) help set up dependencies and exclude the build of heavy assets during development.
- **Deployment**: Convenient deployment script using `rsync` to deploy to the server.
- **Backup**: Backup project without `_site` folder.

## Quick Start

### Installing dependencies

1. Make sure you have the following installed:
   - [Ruby](https://www.ruby-lang.org/) (for Jekyll)
   - p7zip

2. Install Jekyll and Bundler:
```bash
sudo gem i jekyll bundler
```

3. Install 7z for backup:
```
sudo apt install p7zip-full
# for mac
brew install p7zip
```

### Available commands
 - ```npm run dev```: Run development server with rebuilding, LiveReload and provide External address.
 - ```npm run build```: Builds the project for production.
 - ```npm run deploy```: Deploys the project to the server using rsync.
 - ```npm run backup```: Backup the project to parent folder. Format: ```projectname-day-month-year.7z```.

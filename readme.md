# Jekyll Workflow

Ready-to-use workflow for quickly starting with Jekyll, Sass and esbuild. It includes configurations for development, local network access, build, and deployment project.

```
git clone https://github.com/agragregra/jw .; rm -rf trunk readme.md .git
```

### Available commands
- ```npm run dev```: Run development server with rebuilding and LiveReload.
- ```npm run build```: Builds the project for production.
- ```npm run deploy```: Deploys the project to the server using rsync.
- ```npm run backup```: Backup the project. Format: ```projectname-day-month-year.7z```.
- ```npm run preview```: Provide External server address like ```http://192.168.1.126:4000```.

## Features

- **Traditional folders**: Workfwow has traditional dev forler structure with ```src``` and ```dist```.
- **Optimized configurations**: Separate configurations for development (`_config_dev.yml`) and production (`_config.yml`) help set up dependencies and exclude the build of heavy assets during development.
- **Deployment**: Convenient deployment script using `rsync` for deployment to server.
- **Backup**: Backup project.
- **_includes** => **_parts**

## Quick Start

### Installing dependencies

1. Make sure you have the following installed:
   - [Ruby](https://www.ruby-lang.org/) (for Jekyll)
   - [esbuild](https://esbuild.github.io/) (for JS)
   - p7zip

2. Install Jekyll and Bundler:
```bash
sudo gem i jekyll bundler
```

3. Install esbuild:
```
sudo npm i -g esbuild
# or
sudo apt install esbuild
```

4. Install 7z for backup:
```
sudo apt install p7zip-full
# for mac
brew install p7zip
```

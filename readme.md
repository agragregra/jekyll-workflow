# Jekyll Workflow

Ready-to-use workflow for quickly starting with Jekyll, Sass and esbuild. It includes configurations for development, local network access, build, and deployment project.

```
git clone https://github.com/agragregra/jw .; rm -rf trunk .git
chmod +x run.sh && chmod -R 777 .
```

## Features

- **Traditional folders**: Workfwow has traditional dev forler structure with ```src``` and ```dist```.
- **Optimized configurations**: Separate configurations for development (`_config_dev.yml`) and production (`_config.yml`) help set up dependencies and exclude the build of heavy assets during development.
- **Bundling**: Bundling and minification JavaScript files and Sass styles in real time.
- **Deployment**: Deployment from ```dist``` to server using `rsync`.
- **Backup**: Backup project.
- **Docker**: Has a ```docker-compose.yml``` file with jekyll image.
- **path**: Simple include of real relative path level ```{% include path.html -%}``` -> ```{{ path }}```.

## Quick Start

### Use in Docker
```
docker-compose up -d && docker-compose exec jekyll sh
# ./run.sh argument
```

### Available commands
- ```./run.sh dev```: Run development server ```http://127.0.0.1:4000``` with rebuilding and LiveReload (technical: 0.0.0.0).
- ```./run.sh build```: Builds the project for production.
- ```./run.sh deploy```: Deploys the project to the server using ```rsync```.
- ```./run.sh backup```: Backup the project. Format: ```foldername-dd-mm-yyyy.7z```. ```dist``` and ```node_modules``` excluded.
- ```./run.sh preview```: Run external server address ```http://192.168.1.126:3000```.
- ```./run.sh watch```: Just watch and rebuild without server up.

### Installing dependencies (traditional)

1. Make sure you have the following installed:
   - [Ruby](https://www.ruby-lang.org/) (for Jekyll)
   - [esbuild](https://esbuild.github.io/) (for JavaScript)
   - p7zip

2. Install Jekyll and Bundler:
```bash
sudo gem i jekyll bundler
```

3. Install esbuild:
```
sudo npm i -g esbuild
# for mac
brew install esbuild
```

4. Install 7z for backup:
```
sudo apt install p7zip-full
# for mac
brew install p7zip
# for git bash
mkdir -p ~/bin && curl -o ~/bin/7z.exe https://www.7-zip.org/a/7zr.exe
```

5. Install rsync for Git Bash (deploy)
```mkdir -p ~/bin && curl -o ~/bin/rsync.exe https://raw.githubusercontent.com/agragregra/rw/main/rsync.exe```
> For macOS, Linux, etc., no installation is required.

---

> Note: Disable ad blocker to improve performance.

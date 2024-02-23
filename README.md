# Watch and Run

A portable live reload shell command utility for monitor files and rerun command when any files given is changed.

## Install

```sh
git clone https://github.com/snoymy/wandr.git
cd wandr
```

Install locally
```sh
cp ./wandr.sh ~/.local/bin/wandr
chmod +x ~/.local/bin/wandr
```

Or install globally
```sh
sudo cp ./wandr.sh /usr/local/bin/wandr
sudo chmod +x /usr/local/bin/wandr
```

or you can simply copy to where you want to use.

### Uninstall

Uninstall from local
```sh
rm ~/.local/bin/wandr
```

Uninstall from global
```sh
sudo rm /usr/local/bin/wandr
```

## Usage

```
wandr [options] <command> <file1> [<file2> ... <fileN>]
```

### Options

```
-c  Clear terminal screen before reload <command>.
-v  Verbose reloading.
-h  Show help and exit.
```

### Examples

Reload program when main.py is updated:
```
$ wandr "python main.py" main.py
```

Reload program when main.py or lib.py is updated:
```
$ wandr "python main.py" main.py lib.py
```

Reload web server when any .py files in project is added or modified:
```
$ wandr "python server.py" $(find . -name "*.py")
```

or with config file

```
$ wandr "python server.py" $(find . -name "*.py") config.yml
```

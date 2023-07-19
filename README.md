# sql-gen
Bash wrap over aix tool which using ChatGPT API key.

![](./Screenshot.png)

# Installation

```sh
git clone https://github.com/3xyz/sql-gen.git
cd sql-gen/src
# Install and set up aix (if not)
bash setup.sh
```

# Usage

```sh
# Import your DB schemas to schema.txt
# Change dialect in sql_gen.sh
# Enjoy!
sql-gen 'my query'
```

<details>
<summary>sql_gen.sh</summary>
    
```bash
#!/usr/bin/env bash

main() {
  SQL_DIALECT='SQLite'
  SCHEMAS_FILE="$(project_path)/schema.txt"
  query="I have DB ${SQL_DIALECT} with following schemas:\n"
  query+=$(cat ${SCHEMAS_FILE})
  query+="\n\nWrite query which will: "
  query+="$@"
  echo -e $query | aix -silent -duc -nc
}

# Relative path to project
project_path() {
  SOURCE=${BASH_SOURCE[0]}
  while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
  done
  DIR=$( cd -P "$( dirname "$SOURCE" )" > /dev/null 2>&1 && pwd )
  echo $DIR
}

# Start 
main "$@"
```
</details>

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

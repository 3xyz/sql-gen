#!/usr/bin/env bash

# Collor tags
gray="\033[1;30m"
blue="\033[34m"
yellow="\033[40m"
red="\033[31m"
bold="\033[1m"
normal="\033[0m"

init() {
  SILENT=0
  SQL_DIALECT='SQLite'
  SCHEMAS_FILE="$(project_path)/schema.txt"
  CHATGBT_OUT="$(project_path)/chatGBT.json"
}

parse_args() {
  for i in $(seq 1 $#); do
    case ${@:$i:1} in
      -s|--silent)
        let SILENT=1
        ;;
      -h|--help)
        help_message
        exit 0
        ;;
      -*|--*)
        error "unknown option ${bold}${@:$i:1}"
        ;;
      *)
        ;;
    esac
  done
}

main() {
  init
  parse_args "$@"
  query="I have DB ${SQL_DIALECT} with following schemas:\n"
  query+=$(cat ${SCHEMAS_FILE})
  query+="\n\nWrite query which will: "
  query+="$@"
  if [[ $SILENT == 0 ]]; then
    echo -e $query | aix -silent -duc -nc
  else
    echo -e $query | aix -silent -duc -j -o $CHATGBT_OUT > /dev/null
    response_path=$(cat $CHATGBT_OUT | jq '.completion')
    sql_query=''
    md_started=0
    while read line; do
      if [[ ${line::3} =~ ^\`\`\`$ ]]; then
        let md_started++
        continue
      fi
      if (( $md_started == 1 )); then
        sql_query+="${line}\n"
      fi
    # done <<< $(echo -e $(echo "$response_path"))
    done <<< $(echo -e "$response_path")
    if [[ -z $sql_query ]]; then
      error "SQL query not found. Look into file $CHATGBT_OUT"
    else
      echo -e $sql_query
    fi
  fi 
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

help_message() {
  echo -e "${bold}Description:${normal}"
  echo "  Tool for generating sql queries for your DB."
  echo
  echo -e "${bold}Flags:${normal}"
  echo "  -s, --silent    If need to get only sql query"
  echo "  -h, --help      Show this help"
}

error() {
  echo -e " ${red}${bold}Error:${normal} $1" >&2
  exit 1
}

# Start 
main "$@"

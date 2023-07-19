#!/usr/bin/env bash

if ! [[ $(aix) ]]; then
  echo "First of all you need to install aix:"
  echo "https://github.com/projectdiscovery/aix"
  echo 
  echo "This tool need for request ChatGBT through API"
  echo "After install and free API key set up run this script again."
else
  ln -s "$(pwd)/sql_gen.sh" ~/.local/bin/sql-gen
  if [[ $? == 1 ]]; then
    echo 'Something went wring'
  else 
    echo "Created sym link to ~/.local/bin/sql-gen"
    echo "Now you can use tool from everywhere by typing sql-gen 'get all users which have ...'"
    echo "Keep in mind that if you delete this folder or move, you will need to again run setup.sh"
  fi
fi

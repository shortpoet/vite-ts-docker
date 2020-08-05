#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/colors.cfg"
echo -e "${Cyan}The ${Yellow}kanban ${Cyan}build script has been executed${NC}"

docker-compose build --force-rm --no-cache

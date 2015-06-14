#!/bin/bash
#
# Author : Fabio Pinto <fabio@parallel.co.za>
#
# Description : Simple script to start up the data-api container 
#

#VARS
DOCKER_PATH="/usr/bin/docker"
PUBLIC_IP_ALIAS="197.242.66.213"
BIND_PORT="80"
DOCKER_CONTAINER_IMAGE="placementpartner_api"
ARG=$1

#FUNCTIONS

build() {
	clear
        echo "Building DATA-API container..."
        echo

	#Docker build command
	$DOCKER_PATH build -t $DOCKER_CONTAINER_IMAGE .

	check_success
}

run() {
	clear
	echo "Starting DATA-API container..."
	echo

	#Docker run command
	$DOCKER_PATH run -d -p $PUBLIC_IP_ALIAS:$BIND_PORT:$BIND_PORT -e PORT=$BIND_PORT $DOCKER_CONTAINER_IMAGE

	check_success
}

check_success() {
	#Check for success
        if [ $? -ne 0 ]
                then
                        echo ""
                        echo "FAILURE: Something went horribly wrong!"
                        echo ""
                else
			if [ "$ARG" == "-run" ]
				then
                        		echo "SUCCESS: Listing running containers:"
                        		echo ""
                        		$DOCKER_PATH ps
				else
					echo "SUCCESS: Listing container images:"
                                        echo ""
                                        $DOCKER_PATH images
			fi
        fi
}

#EXECUTION
case $ARG in
        '-build')
                build
                ;;
        '-run')
                run
                ;;
        '-h' | *)
                clear
                echo ""
                echo "Script Options: "
                echo "          -build  'Builds the DATA-API container image'"
                echo "          -run    'Runs the built DATA-API image on the local Docker environment'"
                echo ""
                ;;
esac

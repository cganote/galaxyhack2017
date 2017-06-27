#!$shell

$headers
$integrity_injection
$slots_statement
export GALAXY_SLOTS
PRESERVE_GALAXY_ENVIRONMENT="$preserve_python_environment"
GALAXY_LIB="$galaxy_lib"
if [ "$GALAXY_LIB" != "None" -a "$PRESERVE_GALAXY_ENVIRONMENT" = "True" ]; then
    if [ -n "$PYTHONPATH" ]; then
        PYTHONPATH="$GALAXY_LIB:$PYTHONPATH"
    else
        PYTHONPATH="$GALAXY_LIB"
    fi
    export PYTHONPATH
fi
$env_setup_commands
GALAXY_VIRTUAL_ENV="$galaxy_virtual_env"
if [ "$GALAXY_VIRTUAL_ENV" != "None" -a -z "$VIRTUAL_ENV" \
     -a -f "$GALAXY_VIRTUAL_ENV/bin/activate" -a "$PRESERVE_GALAXY_ENVIRONMENT" = "True" ]; then
    . "$GALAXY_VIRTUAL_ENV/bin/activate"
fi

$instrument_pre_commands
LOCALCWD="$localcwd"
if ["$LOCALCWD" != "None"]; then
    mkdir -p $LOCALCWD
    cd $LOCALCWD
    $command
    EXIT=$?
    echo $EXIT > $exit_code_path
    if [ $EXIT == 0 ]; then
	cp -r ${LOCALCWD}/* $working_directory
    fi
else
    cd $working_directory
    $command
    echo $? > $exit_code_path
fi
$instrument_post_commands

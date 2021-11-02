#!/bin/bash

/app/env-init.sh -y
/app/.venv/bin/pyre check

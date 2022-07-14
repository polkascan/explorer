#!/bin/sh
#
# Polkascan Explorer
#
# Copyright 2018-2022 Stichting Polkascan (Polkascan Foundation).
# This file is part of Polkascan.
#
# Polkascan is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Polkascan is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Polkascan. If not, see <http://www.gnu.org/licenses/>.
#
echo "Init Git submodules ..."
git submodule update --init --recursive
echo "Copying explorer-ui-config.json to submodule ..."
cp explorer-ui-config.json explorer-ui/src/assets/config.json
echo "Done. Run 'docker-compose up --build' to build and start application"

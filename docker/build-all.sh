#!/bin/bash
#
# Copyright (C) 2014-2026 Philip Helger (www.helger.com)
# philip[at]helger[dot]com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Builds and pushes the Docker image of the command line client for amd64 and arm64.
# Run it from this directory, after "mvn install" of the released version.

version=11.0.0

#echo Docker login
#echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin

set -e

# The Dockerfile copies the shaded JAR from target/ - it must be exactly the one of this version
jars=(../ph-schematron-cli/target/ph-schematron-cli-*-shaded.jar)
if [ ${#jars[@]} -ne 1 ] || [ "${jars[0]}" != "../ph-schematron-cli/target/ph-schematron-cli-$version-shaded.jar" ]; then
  echo "Expected exactly ph-schematron-cli/target/ph-schematron-cli-$version-shaded.jar, found: ${jars[*]}"
  exit 1
fi

echo Starting buildx
docker buildx rm ph-schematron || true
docker buildx create --name ph-schematron --driver docker-container

docker buildx build --builder ph-schematron --platform=linux/amd64,linux/arm64 --push --pull -t phelger/schematron:$version -t phelger/schematron:latest -f ../ph-schematron-cli/Dockerfile ../ph-schematron-cli

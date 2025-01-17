#!/bin/bash
# Remove any existing containers (ignore errors if no containers are found)
docker rm -f $(docker ps -aq) 2>/dev/null || true

# Run Docker container with corrected format and line continuation
docker run -it --name spark_container \
  -p 8888:8888 \
  -p 4040:4040 \
  -v "$HOME/spark-advanced/code":/home \
  "spark:latest" /bin/bash

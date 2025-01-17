docker rm -f $(docker ps -aq)
docker run -it --name spark_container \
  -p 8888:8888 \
  -p 4040:4040 \
  -v "$HOME/class/code":/home \
  spark \
  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --notebook-dir=/home

# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages: Java, Python, wget, and other dependencies
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk python3 python3-pip python3-venv wget curl scala && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Apache Spark
ENV SPARK_VERSION=3.5.3
RUN wget https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar xvf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Set environment variables for Spark
ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$PATH"

# Install PySpark, Findspark, and Jupyter Notebook
RUN pip3 install --no-cache-dir pyspark findspark jupyter

# Create the Jupyter config directory and configure Jupyter Notebook to work with Spark
RUN mkdir -p ~/.jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py

# Set Python3 as the default Python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Almond (Scala kernel for Jupyter)
ENV ALMOND_VERSION=0.13.4
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier launch --fork almond:${ALMOND_VERSION} -- --install && \
    rm coursier

# Verify installations
RUN java -version && \
    python --version && \
    spark-submit --version && \
    scala -version && \
    jupyter --version && \
    python -m pip show pyspark

# Expose Jupyter Notebook port
EXPOSE 8888

# Set the default command to start Jupyter Notebook
CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
